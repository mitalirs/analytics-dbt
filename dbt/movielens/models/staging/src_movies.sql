WITH raw_movies as (
    SELECT * FROM MOVIELENS.RAW.RAW_MOVIES
)

select 
    movieId as movie_id,
    title,
    genres
from raw_movies
