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
        date = e.published
        categories = ['Blogging', 'Demo'] # Add your desired categories
        tags = ['typography'] # Add your desired tags

        # Create the YAML front matter
        front_matter = {
          'title' => title,
          'author' => 'Your Author Name', # Replace with the actual author name
          'date' => date,
          'categories' => categories,
          'tags' => tags,
          'pin' => true,
          'math' => true,
          'mermaid' => true,
          'image' => {
            'path' => '/commons/devices-mockup.png',
            'lqip' => 'data:image/webp;base64,UklGRpoAAABXRUJQVlA4WAoAAAAQAAAADwAABwAAQUxQSDIAAAARL0AmbZurmr57yyIiqE8oiG0bejIYEQTgqiDA9vqnsUSI6H+oAERp2HZ65qP/VIAWAFZQOCBCAAAA8AEAnQEqEAAIAAVAfCWkAALp8sF8rgRgAP7o9FDvMCkMde9PK7euH5M1m6VWoDXf2FkP3BqV0ZYbO6NA/VFIAAAA',
            'alt' => 'Responsive rendering of Chirpy theme on multiple devices.'
          }
        }

        # Combine YAML front matter with content
        document_content = "#{front_matter.to_yaml}\n---\n#{content}"

        # Create the Jekyll document
        path = "_posts/#{date.strftime('%Y-%m-%d')}-#{title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')}.md"
        path = site.in_source_dir(path)
        doc = Jekyll::Document.new(path, { :site => site, :collection => jekyll_coll })
        doc.content = document_content
        jekyll_coll.docs << doc
      end
    end
  end
end
