require 'toc'
require 'gsub'
require 'deeplink'
require 'sanitizer'

Awestruct::Extensions::Pipeline.new do
  extension Awestruct::Extensions::DataDir.new

  extension Awestruct::Extensions::Indexifier.new
  helper Awestruct::Extensions::Partial
  extension TOC.new(:levels => 2)

  helper Awestruct::Extensions::GoogleAnalytics
  helper Awestruct::Extensions::Sanitizer

  transformer Awestruct::Extensions::Gsub.new(
    /\<!--\s*lang:\s*ceylon\s*--\>\s*<pre><code>(.*?)<\/code><\/pre>/, 
    "<pre class=\"brush: ceylon\">\\1</pre>")
  transformer Awestruct::Extensions::Gsub.new(
    /\<!--\s*lang:\s*java\s*--\>\s*<pre><code>(.*?)<\/code><\/pre>/, 
    "<pre class=\"brush: java\">\\1</pre>")
  transformer Awestruct::Extensions::Gsub.new(
    /\<!--\s*lang:\s*bash\s*--\>\s*<pre><code>(.*?)<\/code><\/pre>/, 
    "<pre class=\"brush: bash\">\\1</pre>")
  transformer Awestruct::Extensions::Gsub.new(
    /\<!--\s*lang:\s*js\s*--\>\s*<pre><code>(.*?)<\/code><\/pre>/, 
    "<pre class=\"brush: js\">\\1</pre>")
  transformer Awestruct::Extensions::Gsub.new(
    /\<!--\s*lang:\s*javascript\s*--\>\s*<pre><code>(.*?)<\/code><\/pre>/, 
    "<pre class=\"brush: javascript\">\\1</pre>")
  transformer Awestruct::Extensions::Gsub.new(
    /\<!--\s*lang:\s*none\s*--\>\s*<pre><code>(.*?)<\/code><\/pre>/, 
    "<pre><code>\\1</code></pre >")
  transformer Awestruct::Extensions::Gsub.new(
    /<pre><code>(.*?)<\/code><\/pre>/, 
    "<pre class=\"brush: ceylon\">\\1</pre>")
  transformer Awestruct::Extensions::Gsub.new(
    /\<!--\s*m1\s*--\>\s*/, 
    "<span class='milestone'><a href='/documentation/roadmap/#milestone_1' title='Support for this feature was introduced in Milestone 1'>Milestone 1</a></span>")
  transformer Awestruct::Extensions::Gsub.new(
    /\<!--\s*m2\s*--\>\s*/, 
    "<span class='milestone future'><a href='/documentation/roadmap/#milestone_2' title='Support for this feature will be introduced in Milestone 2'>Milestone 2</a></span>")
  transformer Awestruct::Extensions::Gsub.new(
    /\<!--\s*m3\s*--\>\s*/, 
    "<span class='milestone future'><a href='/documentation/roadmap/#milestone_3' title='Support for this feature will be introduced in Milestone 3'>Milestone 3</a></span>")
    
  transformer Awestruct::Extensions::DeepLink.new
end



