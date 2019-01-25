### Setting up
Make sure that you have the following in config/application.yml:
```yaml
ROOT_URL: "url_provided_by_ngrok"
provider_1: "url_of_provider_1"
provider_2: "url_of_provider_2"
```

### Running the app
```bash
$ rails s
$ ./ngrok http 3000
$ rake run
```
