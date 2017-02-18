# *Flix for iOS*

**Flix** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

By: **Pedro Sandoval Segura**


## Video Walkthrough

<img src='http://i.imgur.com/huTFiAO.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />


## User Stories - Upgrades being worked on
- Movies are displayed using a CollectionView instead of a TableView.
- All images fade in as they are loading.
- For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- Customize the selection effect of the cell.


## User Stories - Functionality

- User can view a list of movies currently playing in theaters from The Movie Database.
- Poster images are loaded using the UIImageView category in the AFNetworking library.
- User sees a loading state while waiting for the movies API.
- User can pull to refresh the movie list.
- User sees an error message when there's a networking error.
- User can search for a movie.
- User can view the large movie poster by tapping on a cell.
- Scroll view for smooth scrolling in detail view
- Icons in tab view with credit to Noun Project
- Tab bar views: now playing, top rated, upcoming
    - Top Rated category shows ranking with numbers
- Refreshing allows user to see the last time the app refreshed


## License

    Copyright 2017 Pedro Sandoval Segura

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
