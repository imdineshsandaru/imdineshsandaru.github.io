---
layout: categories
icon: fas fa-stream
order: 1
---
<div class="post-list">
  {% for post in site.external_feed %}
    <article class="post">
      <h1><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h1>
      <p class="post-meta">{{ post.date | date: "%B %-d, %Y" }}</p>
      <div class="post-content">
        {{ post.feed_content | markdownify }}
      </div>
    </article>
  {% endfor %}
</div>
