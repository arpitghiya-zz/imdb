## Init Variables

# Specify the Year for which the data is to be fetched
$year = "2015"   

#Specify the minimum rating to filter titles
$rating = "7"

#Specify the minimm votes to filter titles
$votes = "50000"

$file_name = "watchlist_$year.html"

if (Test-Path $file_name) {
    Remove-Item $file_name
}

Function CheckTitleDetails
{
    Param ([string]$title_id)
    $title_id = $title_id.ToString().Trim("/")
    [xml]$title_details = wget "http://www.omdbapi.com/?i=$title_id&plot=short&r=xml"
    $movie_title = $title_details.root.movie.title
    $movie_rating = $title_details.root.movie.imdbRating 
    $movie_votes = $title_details.root.movie.imdbVotes
    $movie_genre = $title_details.root.movie.genre
    $movie_actors = $title_details.root.movie.actors
    $movie_plot = $title_details.root.movie.plot
    if ($title_details.root.movie.type -eq "movie") {
        if ($movie_rating -ge $rating -and [int]$movie_votes -gt $votes) {
            Write-Host "Good Movie: $movie_title ----------------- $movie_rating / $movie_votes"
            ## download poster here
            $poster_url = $title_details.root.movie.poster
            $file = $movie_title
            $file = $file -replace '[\W]',''
            $poster_file = "posters\" + $file + ".jpg"
            if (Test-Path $poster_file) {
            } else {
                $wc = New-Object System.Net.WebClient
                Try {
                    $wc.DownloadFile($poster_url, $poster_file)
                    }
                Catch {
                    Write-Host "Error while downloading poster"
                    Write-Host "DEBUG: " + $poster_url
                    Write-Host "DEBUG: " + $poster_file
                }
            }
            Add-content $file_name -value "<h1> $movie_title</h1><p>"
            Add-Content $file_name -value "<img src=`"$poster_file`">"
            Add-content $file_name -value "<br><b>Genre:</b> $movie_genre"
            Add-content $file_name -value "<br><b>Actors:</b> $movie_actors"
            Add-content $file_name -value "<br><b><i>Plot:</b> $movie_plot</i>"
            Add-content $file_name -value "<br><b>Rating:</b> $movie_rating ($movie_votes <u>votes</u>)</p>"
            }
        }
}

for ($a = 1; $a -le 12; $a++) {
if ($a -lt 10){
    $URI = "www.imdb.com/movies-coming-soon/$year-0$a"
} else {
    $URI = "www.imdb.com/movies-coming-soon/$year-$a"
}
$HTML = Invoke-WebRequest -Uri $URI

$parsed_html = $HTML.ParsedHtml.getElementsByTagName('h4')

$index_length = $parsed_html.length

for ($i = 0; $i -lt $index_length; $i++) {

    $temp_title = $parsed_html[$i].innerHtml
    if ($temp_title.Contains("title")) {
        [xml]$title = $temp_title
        $url = $title.a.href
        $title_id = [regex]::Match($url, '\/tt\d{7}')
        CheckTitleDetails $title_id
    }
}
}