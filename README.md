# Shodan Result Scrape
This script scrape Shodan.io result and save host IP on a text file.

You don't need a paid account to access to Shodan.io APIs. You must provide only your Shodan credentials, a filename to store results. and - of course - the query you want to scrape!
 
Scrape script will login on account.shodan.io and will scrape *ALL* Shodan results (50 results if you have a free account or 10.000 if you have a paid one).
 
## Usage 
```
shodan.rb (c)2016 Salvatore Ansani <salvatore@ansani.it>

Usage:

    -U, --username NAME              Your Shodan.io username
    -P, --password PASSWORD          Your Shodan.io password
    -O, --output FILENAME            Append all output to specified filename
    -Q, --query QUERY                Use this query to search Shodan.io. Put your query between " " and use escape sequence \" to use a double quote. For example: --query "title: \"some keywords\" country:IT"
    -h, --help                       Displays Help

```

 
## Q&A
 
**Q**: Will my credit be touched for use your script ?

**A**: Absolutely NOT! You can use this script how many time you want and your credit (query and download credit) will left intact.


**Q**: Will Shodan.io ban my account for using your script ?

**A**: Yes! They ban your account if they detect you use this script! Read [here](https://www.reddit.com/r/IOT/comments/4shtk1/script_how_to_scrape_shodanio/d59d6pa)

**Q**: Why you wasted your time realizing this piece of sh*t ?

**A**: Because I really need some piece of sh*t like this :)
 
## Examples
```
shodan.rb -U USERNAME -P PASSWORD -O OUTPUT_FILE -Q "QUERY"
```

or, if you like the long format

```
shodan.rb --username USERNAME --password PASSWORD --output OUTPUT_FILE --query "QUERY"
```


If you want to search for all device who have a screenshot stored on Shodan.io. and store all output to your_outputfile.txt simply type:
 
```
shodan.rb --username USERNAME --password PASSWORD --output your_outputfile.txt --query "has_screenshot:true"
```
 
You can also concatenate different search terms:
 
```
shodan.rb --username USERNAME --password PASSWORD --output your_outputfile.txt --query "has_screenshot:true title:\"Cisco Router\""
```
 

## Search query syntax

You can use **SAME** query syntax you use on Shodan.io website.

*This is an extract of Shodan.io query HELP:*

**query:** [String] Shodan search query. The provided string is used to search the database of banners in Shodan, with the additional option to provide filters inside the search query using a "filter:value" format. For example, the following search query would find Apache webservers located in Germany: "apache country:DE". 

The following filters are currently supported:


* **after** Only show results that were collected after the given date (dd/mm/yyyy).  
* **asn**	 The Autonomous System Number that identifies the network the device is on.
* **before** Only show results that were collected before the given date (dd/mm/yyyy.
* **city** Show results that are located in the given city.
* **country** Show results that are located within the given country.
* **geo** There are 2 modes to the geo filter: radius and bounding box. To limit results based on a radius around a pair of latitude/ longitude, provide 3 parameters; ex: geo:50,50,100. If you want to find all results within a bounding box, supply the top left and bottom right coordinates for the region; ex: geo:10,10,50,50.
* **has_screenshot** If "true" only show results that have a screenshot available.
* **hostname** Search for hosts that contain the given value in their hostname.
* **html** Search the HTML of the website for the given value.
* **isp** Find devices based on the upstream owner of the IP netblock.
* **link** Find devices depending on their connection to the Internet.
* **net** Search by netblock using CIDR notation; ex: net:69.84.207.0/24
* **org** Find devices based on the owner of the IP netblock.
* **os** Filter results based on the operating system of the device.
* **port** Find devices based on the services/ ports that are publicly exposed on the Internet.
* **postal** Search by postal code.
* **product** Filter using the name of the software/ product; ex: product:Apache
* **state** Search for devices based on the state/ region they are located in.
* **title** Search the title of the website.
* **version** Filter the results to include only products of the given version; ex: product:apache version:1.3.37


* **bitcoin.ip** Find Bitcoin servers that had the given IP in their list of peers.
* **bitcoin.ip_count** Find Bitcoin servers that return the given number of IPs in the list of peers.
* **bitcoin.port** Find Bitcoin servers that had IPs with the given port in their list of peers.
* **bitcoin.version** Filter results based on the Bitcoin protocol version.


* **ntp.ip** Find NTP servers that had the given IP in their monlist.
* **ntp.ip_count** Find NTP servers that return the given number of IPs in the initial monlist response.
* **ntp.more** Whether or not more IPs were available for the given NTP server.
* **ntp.port** Find NTP servers that had IPs with the given port in their monlist.


## Requirements
You will require the [colorize](https://github.com/fazibear/colorize) and [curb](https://github.com/taf2/curb) module for this.  
```
gem install colorize
gem install curb
```


## Coffee
All coffee donations can go to salvatore@ansani.it ;)
