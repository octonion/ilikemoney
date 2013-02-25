#!/usr/bin/python

import csv
import lxml.html as lh

base = 'http://scoweb.sco.ca.gov/UCP/NoticeDetails.aspx'

# ID range
first = 1
last = 1000

path = '//*[@id="HolderDetailsTable" or @id="PropertyDetailsTable"]'

results = csv.writer(file(r'ucp.csv','wb'))

for id in range(first,last+1):

    url = '%s/?propertyRecID=%s' % (base,id)

    while True:
        try:
            page = lh.parse(url)
            break
        except:
            print "  -> error, retrying\n"
            continue

    row = [id]
    for table in page.xpath(path):
        for tr in table.xpath('tr'):
            for j,td in enumerate(tr.xpath('td')):
                if (j==1):
                    row += [td.xpath("string()").encode('utf-8').strip()]

    results.writerow(row)

    results.flush()
  
results.close
