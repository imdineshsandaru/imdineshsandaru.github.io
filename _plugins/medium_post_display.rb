require 'feedjira'
require 'httparty'

module Jekyll
  class MediumPostDisplay < Generator
    safe true
    priority :high

    def generate(site)
      jekyll_coll = Jekyll::Collection.new(site, 'external_feed')
      site.collections['external_feed'] = jekyll_coll
      xml = HTTParty.get("https://medium.com/feed/@imdineshsandaru").body
      feed = Feedjira.parse(xml)
      generator = feed.respond_to?(:generator) ? feed.generator : nil

      feed.entries.each do |e|
        p "Title: #{e.title}, published on Medium #{e.url} #{e}"
        title = e.title
        content = e.content
        guid = e.url
        path = "./_external_feed/" + title + ".md"
        path = site.in_source_dir(path)
        doc = Jekyll::Document.new(path, { :site => site, :collection => jekyll_coll })
        doc.data['title'] = title
        doc.data['feed_content'] = content
        doc.data['guid'] = guid # Assuming you want to store the URL as a unique identifier
        doc.data['generator'] = generator # Add the generator attribute
        jekyll_coll.docs << doc
      end
    end
  end
end
