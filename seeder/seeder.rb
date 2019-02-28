require 'uri'

pages << {
    page_type: 'products_listing',
    method: 'GET',
    url: "https://www.allyouneedfresh.de/info/getraenke-energy-drinks?catid=4996",
    fetch_type:"fullbrowser",
    vars: {
        'input_type' => 'taxonomy',
        'search_term' => '-',
        'page' => 1
    }


}

search_terms = ["Red Bull", "RedBull", "Energy Drink", "Energy Drinks"]
search_terms.each do |search_term|
  pages << {
      page_type: 'products_listing',
      method: 'GET',
      fetch_type:"fullbrowser",
      url: "https://www.allyouneedfresh.de/suchen?term=redbull#{URI.encode(search_term)}",
      vars: {
          'input_type' => 'search',
          'search_term' => search_term,
          'page' => 1
      }


  }

end