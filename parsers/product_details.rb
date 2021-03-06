body = Nokogiri.HTML(content)


id = content[/(?<=articleNr':')(.+?)(?=')/]

title = body.at("h1").text.gsub(/[\n\s]+/, ' ').strip rescue ''

availability = (content.include? "sofort lieferbar") ? "1" : ""


category = body.css(".breadcrumb-round li").last.text.strip

brand = body.at("h1 a").text

promotion_text = body.at(".card-sale-top").text.strip rescue ""


description = body.css(".product-description.details-bottom").text.gsub(/Produktdetails[^{]*\Z/, '').gsub(/[\s\n,]+/, ' ')

image_url = content[/(?<="image":")(.+?)(?=")/]

price = content[/(?<="price":")(.+?)(?=")/]
item_size = nil
uom = nil
in_pack = nil

[title, description].each do |size_text|
  next unless size_text
  regexps = [
      /(\d*[\.,]?\d+)\s?([Ff][Ll]\.?\s?[Oo][Zz])/,
      /(\d*[\.,]?\d+)\s?([Oo][Zz])/,
      /(\d*[\.,]?\d+)\s?([Ff][Oo])/,
      /(\d*[\.,]?\d+)\s?([Ee][Aa])/,
      /(\d*[\.,]?\d+)\s?([Ff][Zz])/,
      /(\d*[\.,]?\d+)\s?(Fluid Ounces?)/,
      /(\d*[\.,]?\d+)\s?([Oo]unce)/,
      /(\d*[\.,]?\d+)\s?([Cc][Ll])/,
      /(\d*[\.,]?\d+)\s?([Mm][Ll])/,
      /(\d*[\.,]?\d+)\s?([Ll])/,
      /(\d*[\.,]?\d+)\s?([Gg])/,
      /(\d*[\.,]?\d+)\s?([Ll]itre)/,
      /(\d*[\.,]?\d+)\s?([Ss]ervings)/,
      /(\d*[\.,]?\d+)\s?([Pp]acket\(?s?\)?)/,
      /(\d*[\.,]?\d+)\s?([Cc]apsules)/,
      /(\d*[\.,]?\d+)\s?([Tt]ablets)/,
      /(\d*[\.,]?\d+)\s?([Tt]ubes)/,
      /(\d*[\.,]?\d+)\s?([Cc]hews)/,
      /(\d*[\.,]?\d+)\s?([Mm]illiliter)/i,
  ]
  regexps.find {|regexp| size_text =~ regexp}
  item_size = $1
  uom = $2

  break item_size, uom if item_size && uom
end

unless item_size.nil?
  item_size = item_size.gsub(/,/, '.')
end

[title, description].each do |size_text|
  match = [
      /(\d+)\s?[xX]/,
      /Pack of (\d+)/,
      /Box of (\d+)/,
      /Case of (\d+)/,
      /(\d+)\s?[Cc]ount/,
      /(\d+)\s?[Cc][Tt]/,
      /(\d+)[\s-]?Pack($|[^e])/,
      /(\d+)[\s-]pack($|[^e])/,
      /(\d+)[\s-]?[Pp]ak($|[^e])/,
      /(\d+)[\s-]?Tray/,
      /(\d+)\s?[Pp][Kk]/,
      /(\d+)\s?([Ss]tuks)/i,
      /(\d+)\s?([Pp]ak)/i,
      /(\d+)\s?([Pp]ack)/i,
      /[Pp]ack\s*of\s*(\d+)/,
  ].find {|regexp| size_text =~ regexp}
  in_pack = $1

  break in_pack if in_pack
end


in_pack ||= '1'


product_details = {
    # - - - - - - - - - - -
    RETAILER_ID: '120',
    RETAILER_NAME: 'allyouneedfresh',
    GEOGRAPHY_NAME: 'DE',
    # - - - - - - - - - - -
    SCRAPE_INPUT_TYPE: page['vars']['input_type'],
    SCRAPE_INPUT_SEARCH_TERM: page['vars']['search_term'],
    SCRAPE_INPUT_CATEGORY: page['vars']['input_type'] == 'taxonomy' ? category : '-',
    SCRAPE_URL_NBR_PRODUCTS: page['vars']['SCRAPE_URL_NBR_PRODUCTS'],
    # - - - - - - - - - - -
    SCRAPE_URL_NBR_PROD_PG1: page['vars']['SCRAPE_URL_NBR_PRODUCTS_PG1'],
    # - - - - - - - - - - -
    PRODUCT_BRAND: brand,
    PRODUCT_RANK: page['vars']['rank'],
    PRODUCT_PAGE: page['vars']['page'],
    PRODUCT_ID: id,
    PRODUCT_NAME: title,
    PRODUCT_DESCRIPTION: description,
    PRODUCT_MAIN_IMAGE_URL: image_url,
    PRODUCT_ITEM_SIZE: (item_size rescue ''),
    PRODUCT_ITEM_SIZE_UOM: (uom rescue ''),
    PRODUCT_ITEM_QTY_IN_PACK: (in_pack rescue ''),
    SALES_PRICE: price,
    IS_AVAILABLE: availability,
    PROMOTION_TEXT: promotion_text,
    EXTRACTED_ON: Time.now.to_s,

}
product_details['_collection'] = 'products'


outputs << product_details
