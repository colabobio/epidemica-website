---
title: News
permalink: /news
additional_css: news.css
---

<div class="lang-en">

# News & Updates

<div class="news-container">
  {% assign sorted_posts = site.posts | sort: 'date' | reverse %}
  {% for post in sorted_posts limit: 10 %}
  <article class="news-card">
    <div class="news-content">
      <h3 class="news-title">
        {% if post.external_url %}
        <a href="{{ post.external_url }}" target="_blank" rel="noopener noreferrer">{{ post.title }}</a>
        {% else %}
        <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
        {% endif %}
      </h3>
      <time class="news-date">{{ post.date | date: "%B %d, %Y" }}</time>
      <p class="news-excerpt">{{ post.excerpt | strip_html | truncatewords: 30 }}</p>
      <div class="news-meta">
        {% if post.external_url %}
        <a href="{{ post.external_url }}" target="_blank" rel="noopener noreferrer" class="read-more">Read more →</a>
        {% else %}
        <a href="{{ post.url | relative_url }}" class="read-more">Read more →</a>
        {% endif %}
      </div>
    </div>
  </article>
  {% endfor %}
  
  {% if site.posts.size == 0 %}
  <div class="no-news">
    <p>No news updates yet. Check back soon for the latest updates on Epidemica!</p>
  </div>
  {% endif %}
</div>
</div>

<div class="lang-vi" style="display:none">

# Tin tức & Cập nhật

<div class="news-container">
  {% assign sorted_posts = site.posts | sort: 'date' | reverse %}
  {% for post in sorted_posts limit: 10 %}
  <article class="news-card">
    <div class="news-content">
      <h3 class="news-title">
        {% if post.external_url %}
        <a href="{{ post.external_url }}" target="_blank" rel="noopener noreferrer">{{ post.title }}</a>
        {% else %}
        <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
        {% endif %}
      </h3>
      <time class="news-date">{{ post.date | date: "%d tháng %m năm %Y" }}</time>
      <p class="news-excerpt">{{ post.excerpt | strip_html | truncatewords: 30 }}</p>
      <div class="news-meta">
        {% if post.external_url %}
        <a href="{{ post.external_url }}" target="_blank" rel="noopener noreferrer" class="read-more">Đọc thêm →</a>
        {% else %}
        <a href="{{ post.url | relative_url }}" class="read-more">Đọc thêm →</a>
        {% endif %}
      </div>
    </div>
  </article>
  {% endfor %}
  
  {% if site.posts.size == 0 %}
  <div class="no-news">
    <p>Chưa có tin tức cập nhật. Hãy kiểm tra lại sớm để biết thêm thông tin mới nhất về Epidemica!</p>
  </div>
  {% endif %}
</div>

</div>