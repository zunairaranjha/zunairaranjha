module IdentityCache
  module ConfigurationDSL
    extend ActiveSupport::Concern

    included do |base|
      base.class_attribute :cache_indexes
      base.class_attribute :cached_has_manys
      base.class_attribute :cached_has_ones
      base.class_attribute :primary_cache_index_enabled

      base.cached_has_manys = {}
      base.cached_has_ones = {}
      base.cache_indexes = []
      base.primary_cache_index_enabled = true

      base.after_commit :expire_parent_caches
    end

    module ClassMethods
      # Declares a new index in the cache for the class where IdentityCache was
      # included.
      #
      # IdentityCache will add a fetch_by_field1_and_field2_and_...field for every
      # index.
      #
      # == Example:
      #
      #  class Product
      #    include IdentityCache
      #    cache_index :name, :vendor
      #  end
      #
      # Will add Product.fetch_by_name_and_vendor
      #
      # == Parameters
      #
      # +fields+ Array of symbols or strings representing the fields in the index
      #
      # == Options
      # * unique: if the index would only have unique values
      #
      def cache_index(*fields)
        raise NotImplementedError, "Cache indexes need an enabled primary index" unless primary_cache_index_enabled
        options = fields.extract_options!
        unique = options[:unique] || false
        cache_attribute_by_alias('primary_key', 'id', by: fields, unique: unique)

        field_list = fields.join("_and_")
        arg_list = (0...fields.size).collect { |i| "arg#{i}" }.join(',')

        if unique
          self.instance_eval(ruby = <<-CODE, __FILE__, __LINE__ + 1)
            def fetch_by_#{field_list}(#{arg_list}, options={})
              id = fetch_id_by_#{field_list}(#{arg_list})
              id && fetch_by_id(id, options)
            end

            # exception throwing variant
            def fetch_by_#{field_list}!(#{arg_list}, options={})
              fetch_by_#{field_list}(#{arg_list}, options) or raise ActiveRecord::RecordNotFound
            end
          CODE
        else
          self.instance_eval(ruby = <<-CODE, __FILE__, __LINE__ + 1)
            def fetch_by_#{field_list}(#{arg_list}, options={})
              ids = fetch_id_by_#{field_list}(#{arg_list})
              ids.empty? ? ids : fetch_multi(ids, options)
            end
          CODE
        end
      end


      # Will cache an association to the class including IdentityCache.
      # The embed option, if set, will make IdentityCache keep the association
      # values in the same cache entry as the parent.
      #
      # Embedded associations are more effective in offloading database work,
      # however they will increase the size of the cache entries and make the
      # whole entry expire when any of the embedded members change.
      #
      # == Example:
      #   class Product
      #     include IdentityCache
      #     has_many :options
      #     has_many :orders
      #     has_many :buyers
      #     cache_has_many :options, embed: :ids
      #     cache_has_many :orders
      #     cache_has_many :buyers, inverse_name: 'line_item'
      #   end
      #
      # == Parameters
      # +association+ Name of the association being cached as a symbol
      #
      # == Options
      #
      # * embed: If set to true, will cause IdentityCache to keep the
      #   values for this association in the same cache entry as the parent,
      #   instead of its own.
      # * inverse_name: The name of the parent in the association if the name is
      #   not the lowercase pluralization of the parent object's class
      def cache_has_many(association, options = {})
        ensure_base_model
        options = options.slice(:embed, :inverse_name)
        options[:embed] = :ids unless options.has_key?(:embed)
        deprecate_embed_option(options, false, :ids)
        ensure_cacheable_association(association, options)
        self.cached_has_manys[association] = options

        case options[:embed]
        when true
          build_recursive_association_cache(association, options)
        when :ids
          build_id_embedded_has_many_cache(association, options)
        else
          raise NotImplementedError
        end
      end

      # Will cache an association to the class including IdentityCache.
      # IdentityCache will keep the association values in the same cache entry
      # as the parent.
      #
      # == Example:
      #   class Product
      #     cache_has_one :store, embed: true
      #     cache_has_one :vendor
      #   end
      #
      # == Parameters
      # +association+ Symbol with the name of the association being cached
      #
      # == Options
      #
      # * embed: Only true is supported, which is also the default, so
      #   IdentityCache will keep the values for this association in the same
      #   cache entry as the parent, instead of its own.
      # * inverse_name: The name of the parent in the association ( only
      #   necessary if the name is not the lowercase pluralization of the
      #   parent object's class)
      def cache_has_one(association, options = {})
        ensure_base_model
        options = options.slice(:embed, :inverse_name)
        options[:embed] = true unless options.has_key?(:embed)
        ensure_cacheable_association(association, options)
        self.cached_has_ones[association] = options

        if options[:embed] == true
          build_recursive_association_cache(association, options)
        else
          raise NotImplementedError
        end
      end

      # Will cache a single attribute on its own blob, it will add a
      # fetch_attribute_by_id (or the value of the by option).
      #
      # == Example:
      #   class Product
      #     include IdentityCache
      #     cache_attribute :quantity, by: :name
      #     cache_attribute :quantity, by: [:name, :vendor]
      #   end
      #
      # == Parameters
      # +attribute+ Symbol with the name of the attribute being cached
      #
      # == Options
      #
      # * by: Other attribute or attributes in the model to keep values indexed. Default is :id
      # * unique: if the index would only have unique values. Default is true
      def cache_attribute(attribute, options = {})
        cache_attribute_by_alias(attribute.inspect, attribute, options)
      end

      def disable_primary_cache_index
        ActiveSupport::Deprecation.warn("disable_primary_cache_index is deprecated, use `include IdentityCache::WithoutPrimaryIndex` instead")
        ensure_base_model
        self.primary_cache_index_enabled = false
      end

      private

      def cache_attribute_by_alias(attribute, alias_name, options)
        ensure_base_model
        options[:by] ||= :id
        alias_name = alias_name.to_sym
        unique = options[:unique].nil? ? true : !!options[:unique]
        fields = Array(options[:by])

        self.cache_indexes.push [alias_name, fields, unique]

        field_list = fields.join("_and_")
        arg_list = (0...fields.size).collect { |i| "arg#{i}" }.join(',')

        self.instance_eval(<<-CODE, __FILE__, __LINE__ + 1)
          def fetch_#{alias_name}_by_#{field_list}(#{arg_list})
            attribute_dynamic_fetcher(#{attribute}, #{fields.inspect}, [#{arg_list}], #{unique})
          end
        CODE
      end

      def build_recursive_association_cache(association, options) #:nodoc:
        options[:association_reflection] = reflect_on_association(association)
        options[:cached_accessor_name]   = "fetch_#{association}"
        options[:records_variable_name]  = "cached_#{association}"

        self.class_eval(<<-CODE, __FILE__, __LINE__ + 1)
          def #{options[:cached_accessor_name]}
            fetch_recursively_cached_association('#{options[:records_variable_name]}', :#{association})
          end
        CODE

        options[:only_on_foreign_key_change] = false
        add_parent_expiry_hook(options)
      end

      def build_id_embedded_has_many_cache(association, options) #:nodoc:
        singular_association = association.to_s.singularize
        options[:association_reflection]  = reflect_on_association(association)
        options[:cached_accessor_name]    = "fetch_#{association}"
        options[:ids_name]                = "#{singular_association}_ids"
        options[:cached_ids_name]         = "fetch_#{options[:ids_name]}"
        options[:ids_variable_name]       = "cached_#{options[:ids_name]}"
        options[:records_variable_name]   = "cached_#{association}"
        options[:prepopulate_method_name] = "prepopulate_fetched_#{association}"

        self.class_eval(<<-CODE, __FILE__, __LINE__ + 1)
          attr_reader :#{options[:ids_variable_name]}

          def #{options[:cached_ids_name]}
            @#{options[:ids_variable_name]} ||= #{options[:ids_name]}
          end

          def #{options[:cached_accessor_name]}
            association_klass = association(:#{association}).klass
            if association_klass.should_use_cache? && !#{association}.loaded?
              @#{options[:records_variable_name]} ||= #{options[:association_reflection].klass}.fetch_multi(#{options[:cached_ids_name]})
            else
              #{association}.to_a
            end
          end

          def #{options[:prepopulate_method_name]}(records)
            @#{options[:records_variable_name]} = records
          end
        CODE

        options[:only_on_foreign_key_change] = true
        add_parent_expiry_hook(options)
      end

      def attribute_dynamic_fetcher(attribute, fields, values, unique_index) #:nodoc:
        raise_if_scoped

        if should_use_cache?
          cache_key = rails_cache_key_for_attribute_and_fields_and_values(attribute, fields, values, unique_index)
          IdentityCache.fetch(cache_key) do
            dynamic_attribute_cache_miss(attribute, fields, values, unique_index)
          end
        else
          dynamic_attribute_cache_miss(attribute, fields, values, unique_index)
        end
      end

      def dynamic_attribute_cache_miss(attribute, fields, values, unique_index)
        query = reorder(nil).where(Hash[fields.zip(values)])
        query = query.limit(1) if unique_index
        results = query.pluck(attribute)
        unique_index ? results.first : results
      end

      def add_parent_expiry_hook(options)
        child_class = options[:association_reflection].klass
        unless child_class < IdentityCache
          message = "associated class #{child_class} will need to include IdentityCache or " \
            "IdentityCache::WithoutPrimaryIndex for embedded associations"
          ActiveSupport::Deprecation.warn(message, caller(3))
          child_class.send(:include, IdentityCache::WithoutPrimaryIndex)
        end
        child_class.parent_expiration_entries[options[:inverse_name]] << [self, options[:only_on_foreign_key_change]]
      end

      def deprecate_embed_option(options, old_value, new_value)
        if options[:embed] == old_value
          options[:embed] = new_value
          ActiveSupport::Deprecation.warn("`embed: #{old_value.inspect}` was renamed to `embed: #{new_value.inspect}` for clarity", caller(2))
        end
      end

      def ensure_base_model
        if self != cached_model
          raise DerivedModelError, "IdentityCache class methods must be called on the same model that includes IdentityCache"
        end
      end

      def ensure_cacheable_association(association, options)
        unless association_reflection = self.reflect_on_association(association)
          raise AssociationError, "Association named '#{association}' was not found on #{self.class}"
        end
        if association_reflection.options[:through]
          raise UnsupportedAssociationError, "caching through associations isn't supported"
        end
        options[:inverse_name] ||= association_reflection.inverse_of.name if association_reflection.inverse_of
        options[:inverse_name] ||= self.name.underscore.to_sym
        child_class = association_reflection.klass
        raise InverseAssociationError unless child_class.reflect_on_association(options[:inverse_name])
        unless options[:embed] == true || child_class.include?(IdentityCache)
          raise UnsupportedAssociationError, "associated class #{child_class} must include IdentityCache to be cached without full embedding"
        end
      end
    end
  end
end
