
body = Nokogiri.HTML(content)
products = body.css(".article-link")
scrape_url_nbr_products = products.length


products.take(1).each_with_index do |product, i|
  pages << {
      page_type: 'product_details',
      method: 'GET',
      fetch_type:"fullbrowser",
      url: 'https://www.allyouneedfresh.de/'+product.attr("href") + "&search=#{page['vars']['search_term']}&rank=#{i + 1}",
      vars: {
          'input_type' => page['vars']['input_type'],
          'search_term' => page['vars']['search_term'],
          'SCRAPE_URL_NBR_PRODUCTS' => scrape_url_nbr_products,
          'SCRAPE_URL_NBR_PRODUCTS_PG1' => scrape_url_nbr_products,
          'rank' => i + 1,
          'page' => page['vars']['page']
      }

  }


end

