SELECT albums.id AS album_id,
			albums.title
FROM artists
	JOIN albums
	ON albums.artist_id = artists.id
	WHERE artists.name = 'Nina Simone' AND 
  albums.release_year > '1975'; 
  


