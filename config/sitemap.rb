require 'aws-sdk-s3'

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://elgrocer.com"
SitemapGenerator::Sitemap.sitemaps_host = "https://#{ENV['S3_BUCKET_NAME']}.s3-eu-west-1.amazonaws.com/"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemap-data/'
# SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(Rails.application.credentials.dig(:amazon, :s3, ENV['S3_BUCKET_NAME']),
#                                                                         aws_access_key_id: Rails.application.credentials.dig(:amazon, :s3, ENV['AWS_ACCESS_KEY_ID']),
#                                                                         aws_secret_access_key: Rails.application.credentials.dig(:amazon, :s3, ENV['AWS_SECRET_ACCESS_KEY']),
#                                                                         aws_region: Rails.application.credentials.dig(:amazon, :s3, ENV['AWS_REGION'])

# )

SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(ENV['S3_BUCKET_NAME'],
                                                                        aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                                                                        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
                                                                        aws_region: ENV['AWS_REGION']

)
# SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #

# SitemapGenerator::Sitemap.public_path = File.join(Rails.root, 'tmp').to_s

SitemapGenerator::Sitemap.compress = false

SitemapGenerator::Sitemap.create do

  SitemapData.order(:id).find_each do |smd|
    add smd.loc, :lastmod => smd.lastmod
  end

end
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
# end
