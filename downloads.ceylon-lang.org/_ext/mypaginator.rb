

module Awestruct
  module Extensions
    class MyPaginator

      module Paginated
        attr_accessor :window
        attr_accessor :next_page
        attr_accessor :previous_page
        attr_accessor :current_page
        attr_accessor :current_page_index
        attr_accessor :pages

        def links
          html = %Q(<div class="pagination-links">)
          unless ( previous_page.nil? )
            html += %Q(<a href="#{previous_page.url}" class="previous-link">Previous</a> )
          end
          first_skip = false
          second_skip = false
          pages.each_with_index do |page, i|
            if ( i == current_page_index )
              html += %Q(<span class="current-page">#{i+1}</span> )
            elsif ( i <= window )
              html += %Q(<a href="#{page.url}" class="page-link">#{i+1}</a> )
            elsif ( ( i > window ) && ( i < ( current_page_index - window ) ) && ! first_skip  )
              html += %Q(<span class="skip">...</span>)
              first_skip = true
            elsif ( ( i > ( current_page_index + window ) ) && ( i < ( ( pages.size - window ) - 1 ) ) && ! second_skip )
              html += %Q(<span class="skip">...</span>)
              second_skip = true
            elsif ( ( i >= ( current_page_index - window ) ) && ( i <= ( current_page_index + window ) ) )
              html += %Q(<a href="#{page.url}" class="page-link">#{i+1}</a> )
            elsif ( i >= ( ( pages.size - window ) - 1 ) )
              html += %Q(<a href="#{page.url}" class="page-link">#{i+1}</a> )
            end
          end
          unless ( next_page.nil? )
            html += %Q(<a href="#{next_page.url}" class="next-link">Next</a> )
          end
          html += %Q(</div>)
          html
        end

      end

      def initialize(prop_name, input_path, opts={})
        @prop_name    = prop_name
        @input_path   = input_path
        @per_page     = opts[:per_page] || 20
        @window_size  = opts[:window_size] || 2
        @remove_input = opts.has_key?( :remove_input ) ? opts[:remove_input] : true
        @output_prefix = opts[:output_prefix] || File.dirname( @input_path )
        @collection    = opts[:collection]
        @split_title = opts[:split_title] 
        @author_for_bio = opts[:author_for_bio]
        @blog_tag            = opts[:blog_tag]
      end

      def execute(site)
        removal_path = nil
        all = @collection || site.send( @prop_name )
        i = 1
        paginated_pages = []
        all.each_slice( @per_page ) do |slice|
          page = site.engine.find_and_load_site_page( @input_path )
          removal_path ||= page.output_path
          slice.extend( Paginated )
          page.send( "#{@prop_name}=", slice )
          if ( i == 1 )
            page.output_path = File.join( @output_prefix, File.basename( @input_path ) + ".html" )
          else
            page.output_path = File.join( @output_prefix, "page#{i}.html" )
          end
          page.paginate_generated = true
          site.pages << page
          paginated_pages << page
          i = i + 1
        end 

        if ( @remove_input )
          site.pages.reject!{|page|
            ( ! page.paginate_generated && ( page.output_path == removal_path ) )
          }
        end

        prev_page = nil
        paginated_pages.each_with_index do |page,i|
          page.posts.current_page       = page
          page.posts.current_page_index = i
          page.posts.pages              = paginated_pages
          page.posts.window             = 1
          page.split_title              = @split_title
          page.title              = @split_title
          page.author_for_bio           = @author_for_bio
          page.blog_tag                      = @blog_tag

          if ( prev_page != nil )
            prev_page.send( @prop_name ).next_page = page
            page.send( @prop_name ).previous_page  = prev_page
          end

          prev_page = page
        end

        paginated_pages.first
      end
    end

  end
end
