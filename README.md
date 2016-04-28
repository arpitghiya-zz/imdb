# imdb
Powershell Scripts to Fetch Movie details from IMDB

<i>I have written the following scripts to fetch the list of movies from IMDB (latest DVD releases / year wise releases) and filter it according to my choice!</i>

<h2>1. Latest_Movies.ps1<br></h2>
  This scripts does the following:
  - Gets the latest DVD releases from IMDB website
  - Filters the data according to the 'user' specified <b>RATING</b> and <b>NUMBER_OF_VOTES</b> and sends an email

<h2>2. IMDB_Scraping.ps1<br></h2>
  This is lazy me. I wanted a list of Good movies releases in a particlar year (using the same filters as above). It fetches the data for the movies releases in a calendar year and generates a HTML output of the filtered data
