require 'spec_helper'
require 'action_controller'
require 'active_support/core_ext/kernel/reporting'

InteractionWithFilter = Class.new(TestInteraction) do
  float :thing
end

InteractionWithDateFilter = Class.new(TestInteraction) do
  date :thing
end

AddInteraction = Class.new(TestInteraction) do
  float :x, :y

  def execute
    x + y
  end
end

InterruptInteraction = Class.new(TestInteraction) do
  object :x, :z,
    class: Object,
    default: nil

  # NOTE: the relative position between this method
  #   and the compose line should be preserved.
  def self.composition_location
    "#{__FILE__}:#{__LINE__ + 4}:in `execute'"
  end

  def execute
    compose(AddInteraction, x: x, y: z)
  end
end

describe ActiveInteraction::Base do
  subject(:interaction) { described_class.new(inputs) }

  include_context 'interactions'

  describe '.new(inputs = {})' do
    it 'does not set instance vars for reserved input names' do
      key = :execute
      inputs[key] = nil

      expect(interaction.instance_variable_defined?(:"@#{key}")).to be false
    end

    context 'with a filter' do
      let(:described_class) { InteractionWithFilter }

      context 'validation' do
        context 'failing' do
          before { inputs[:thing] = thing }

          context 'with an invalid value' do
            let(:thing) { 'a' }

            it 'sets the attribute to the filtered value' do
              expect(interaction.thing).to equal thing
            end
          end

          context 'without a value' do
            let(:thing) { nil }

            it 'sets the attribute to the filtered value' do
              expect(interaction.thing).to equal thing
            end
          end
        end

        context 'passing' do
          before { inputs[:thing] = 1 }

          it 'returns a valid outcome' do
            expect(interaction).to be_valid
          end
        end
      end

      context 'with a single input' do
        before { inputs[:thing] = 1 }

        it 'sets the attribute to the filtered value' do
          expect(interaction.thing).to be 1.0
        end
      end

      context 'with multiple inputs' do
        let(:described_class) { InteractionWithDateFilter }
        let(:year) { 2012 }
        let(:month) { 1 }
        let(:day) { 2 }

        before do
          inputs.merge!(
            'thing(1i)' => year.to_s,
            'thing(2i)' => month.to_s,
            'thing(3i)' => day.to_s
          )
        end

        it 'returns a Date' do
          expect(interaction.thing).to eql Date.new(year, month, day)
        end
      end
    end
  end

  describe '.desc' do
    let(:desc) { SecureRandom.hex }

    it 'returns nil' do
      expect(described_class.desc).to be_nil
    end

    context 'with a description' do
      it 'returns the description' do
        expect(described_class.desc(desc)).to eql desc
      end

      it 'saves the description' do
        described_class.desc(desc)
        expect(described_class.desc).to eql desc
      end
    end
  end

  describe '.method_missing(filter_type, *args, &block)' do
    it 'raises an error for an invalid filter type' do
      expect do
        Class.new(TestInteraction) do
          not_a_valid_filter_type :thing
        end
      end.to raise_error NoMethodError
    end

    it do
      expect do
        Class.new(TestInteraction) do
          float :_interaction_thing
        end
      end.to raise_error ActiveInteraction::InvalidFilterError
    end

    context 'with a filter' do
      let(:described_class) { InteractionWithFilter }

      it 'adds an attr_reader' do
        expect(interaction).to respond_to :thing
      end

      it 'adds an attr_writer' do
        expect(interaction).to respond_to :thing=
      end
    end

    context 'with multiple filters' do
      let(:described_class) do
        Class.new(TestInteraction) do
          float :thing1, :thing2
        end
      end

      %w[thing1 thing2].each do |thing|
        it "adds an attr_reader for #{thing}" do
          expect(interaction).to respond_to thing
        end

        it "adds an attr_writer for #{thing}" do
          expect(interaction).to respond_to "#{thing}="
        end
      end
    end
  end

  context 'with a filter' do
    let(:described_class) { InteractionWithFilter }
    let(:thing) { rand }

    it 'warns when redefining a filter' do
      klass = Class.new(described_class)
      allow(klass).to receive(:warn)
      expect(klass.boolean(:thing)).to have_received(:warn).with(/\AWARNING:/)
    end

    describe '.run(inputs = {})' do
      it "returns an instance of #{described_class}" do
        expect(outcome).to be_a described_class
      end

      context 'failing validations' do
        it 'returns an invalid outcome' do
          expect(outcome).to_not be_valid
        end

        it 'sets the result to nil' do
          expect(result).to be_nil
        end
      end

      context 'passing validations' do
        before { inputs[:thing] = thing }

        context 'failing runtime validations' do
          around do |example|
            old_method = described_class.instance_method(:execute)
            described_class.send(:define_method, :execute) do
              errors.add(:thing, 'is invalid')
              errors.add(:thing, :invalid)
              true
            end

            example.run

            silence_warnings do
              described_class.send(:define_method, :execute, old_method)
            end
          end

          it 'returns an invalid outcome' do
            expect(outcome).to be_invalid
          end

          it 'sets the result' do
            expect(result).to be true
          end

          it 'has errors' do
            expect(outcome.errors.messages[:thing]).to eql [
              'is invalid',
              'is invalid'
            ]
          end

          it 'has detailed errors' do
            expect(outcome.errors.details[:thing]).to eql [
              { error: 'is invalid' },
              { error: :invalid }
            ]
          end
        end

        it 'returns a valid outcome' do
          expect(outcome).to be_valid
        end

        it 'sets the result' do
          expect(result[:thing]).to eql thing
        end
      end
    end

    describe '.run!(inputs = {})' do
      subject(:result) { described_class.run!(inputs) }

      context 'failing validations' do
        it 'raises an error' do
          expect do
            result
          end.to raise_error ActiveInteraction::InvalidInteractionError
        end
      end

      context 'passing validations' do
        before { inputs[:thing] = thing }

        it 'returns the result' do
          expect(result[:thing]).to eql thing
        end
      end
    end
  end

  describe '#inputs' do
    let(:described_class) { InteractionWithFilter }
    let(:other_val) { SecureRandom.hex }
    let(:inputs) { { thing: 1, other: other_val } }

    it 'casts filtered inputs' do
      expect(interaction.inputs[:thing]).to be 1.0
    end

    it 'strips non-filtered inputs' do
      expect(interaction.inputs).to_not have_key(:other)
    end
  end

  describe '#compose' do
    let(:described_class) { InterruptInteraction }
    let(:x) { rand }
    let(:z) { rand }

    context 'with valid composition' do
      context 'when inputs is a hash' do
        let(:inputs) { { x: x, z: z } }

        it 'is valid' do
          expect(outcome).to be_valid
        end

        it 'returns the sum' do
          expect(result).to eql x + z
        end
      end

      context 'when inputs is an ActiveInteraction::Inputs' do
        let(:inputs) { ActiveInteraction::Inputs.new({ x: x, z: z }, described_class.new) }

        it 'is valid' do
          expect(outcome).to be_valid
        end

        it 'returns the sum' do
          expect(result).to eql x + z
        end
      end
    end

    context 'with invalid composition' do
      it 'is invalid' do
        expect(outcome).to be_invalid
      end

      it 'has the correct errors' do
        expect(outcome.errors.details)
          .to eql(x: [{ error: :missing }], base: [{ error: 'Y is required' }])
      end

      it 'has the correct backtrace' do
        described_class.run!(inputs)
      rescue ActiveInteraction::InvalidInteractionError => e
        expect(e.backtrace)
          .to include(InterruptInteraction.composition_location)
      end
    end
  end

  describe '#execute' do
    it 'raises an error' do
      expect { interaction.execute }.to raise_error NotImplementedError
    end
  end

  context 'inheritance' do
    context 'filters' do
      let(:described_class) { InteractionWithFilter }

      def filters(klass)
        klass.filters.keys
      end

      it 'includes the filters from the superclass' do
        expect(filters(Class.new(described_class))).to include :thing
      end

      it 'does not mutate the filters on the superclass' do
        Class.new(described_class) { float :other_thing }

        expect(filters(described_class)).to_not include :other_thing
      end
    end

    context 'validators' do
      it 'does not pollute validators' do
        a = Class.new(ActiveInteraction::Base) do
          string :a
          validates_presence_of :a
        end

        b = Class.new(ActiveInteraction::Base) do
          string :b
          validates_presence_of :b
        end

        expect(a.validators).to_not eql b.validators
      end

      it 'gives duped validators to subclasses' do
        a = Class.new(ActiveInteraction::Base) do
          string :a
          validates_presence_of :a
        end

        b = Class.new(a)

        expect(a.validators).to eql b.validators
        expect(a.validators).to_not equal b.validators
      end
    end
  end

  describe '.import_filters' do
    shared_context 'import_filters context' do |only, except|
      let(:klass) { AddInteraction }

      let(:described_class) do
        interaction = klass
        options = {}
        options[:only] = only unless only.nil?
        options[:except] = except unless except.nil?

        Class.new(TestInteraction) { import_filters interaction, options }
      end
    end

    shared_examples 'import_filters examples' do |only, except|
      include_context 'import_filters context', only, except

      it 'imports the filters' do
        expect(described_class.filters).to eql(
          klass.filters
            .select { |k, _| only.nil? ? true : [*only].include?(k) }
            .reject { |k, _| except.nil? ? false : [*except].include?(k) }
        )
      end

      it 'does not modify the source' do
        filters = klass.filters.dup
        described_class
        expect(klass.filters).to eql filters
      end

      it 'responds to readers and writers' do
        instance = described_class.new

        described_class.filters.each_key do |name|
          [name, "#{name}="].each do |method|
            expect(instance).to respond_to method
          end
        end
      end
    end

    context 'with neither :only nor :except' do
      include_examples 'import_filters examples', nil, nil
    end

    context 'with :only' do
      context 'as an Array' do
        include_examples 'import_filters examples', [:x], nil
      end

      context 'as an Symbol' do
        include_examples 'import_filters examples', :x, nil
      end
    end

    context 'with :except' do
      context 'as an Array' do
        include_examples 'import_filters examples', nil, [:x]
      end

      context 'as an Symbol' do
        include_examples 'import_filters examples', nil, :x
      end
    end

    context 'with :only & :except' do
      include_examples 'import_filters examples', [:x], [:x]
    end
  end

  context 'callbacks' do
    let(:described_class) { Class.new(TestInteraction) }

    %w[filter validate execute].each do |name|
      %w[before after around].map(&:to_sym).each do |type|
        it "runs the #{type} #{name} callback" do
          called = false
          described_class.set_callback(name, type) { called = true }
          outcome
          expect(called).to be_truthy
        end
      end
    end

    context 'with errors during filter' do
      before do
        described_class.set_callback(:filter, :before) do
          errors.add(:base)
        end
      end

      it 'is invalid' do
        expect(outcome).to be_invalid
      end

      it 'does not run validate callbacks' do
        called = false
        described_class.set_callback(:validate, :before) { called = true }
        outcome
        expect(called).to be_falsey
      end

      it 'does not run execute callbacks' do
        called = false
        described_class.set_callback(:execute, :before) { called = true }
        outcome
        expect(called).to be_falsey
      end
    end

    context 'with errors during validate' do
      before do
        described_class.set_callback(:validate, :before) do
          errors.add(:base)
        end
      end

      it 'is invalid' do
        expect(outcome).to be_invalid
      end

      it 'does not run execute callbacks' do
        called = false
        described_class.set_callback(:execute, :before) { called = true }
        outcome
        expect(called).to be_falsey
      end
    end

    context 'with errors during execute' do
      before do
        described_class.set_callback(:execute, :before) do
          errors.add(:base)
        end
      end

      it 'is invalid' do
        expect(outcome).to be_invalid
      end
    end
  end
end
