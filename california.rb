#!/usr/bin/ruby1.9.3
# -*- coding: utf-8 -*-

require "csv"
require "mechanize"

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = "Mozilla/5.0"

bad = " "

# Alternative is base = "http://scoweb.sco.ca.gov/UCP/PropertyDetails.aspx"
base = "http://scoweb.sco.ca.gov/UCP/NoticeDetails.aspx"

path = '//*[@id="HolderDetailsTable" or @id="PropertyDetailsTable"]'

# ID range
first = 1
last = 1000

results = CSV.open("ucp_#{first}-#{last}.csv","w")

(first..last).each do |id|

  if (id%100==0)
    p id
    results.flush
  end

  url = "#{base}/?propertyRecID=#{id}"

  begin
    page = agent.get(url)
  rescue
    print "  -> #{id} not found\n"
    next
  end

  r = [id]
  page.parser.xpath(path).each do |row| #i

    row.xpath("tr").each_with_index do |tr,j|
      tr.xpath("td").each_with_index do |td,k|
        if (k==0)
          next
        end
        text = td.inner_text
        text.gsub!(bad," ")
        if (j==1)
          text.gsub!("$","")
        end
        text.strip!
        if (text=="")
          r += [nil]
        else
          r << text
        end
      end
    end

  end
  results << r

end

results.close
