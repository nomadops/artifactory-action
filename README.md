# GitHub Action for jFrog Artifactory's CLI

[![CI](https://github.com/nomadops/artifactory-action/actions/workflows/ci.yml/badge.svg)](https://github.com/nomadops/artifactory-action/actions/workflows/ci.yml)

A wrapper to run jFrog CLI commands with Artifactory. This is a fork of [action-jfrog-cli](https://github.com/advancedcsg-open/action-jfrog-cli) (Thank you!!) updated to the latest version and cli syntax of jfrog. It adds support for deploying go artifacts, and adds some logic to allow for repeat use of the action within a single job.

## Usage

### Inputs

| Input | Description | Required | Default |
| --- | --- | --- | --- |
| `url` | The URL to your Artifactory instance. | Yes | N/A |
| `credentials-type` | The type of credentials used to authenticate with Artifactory. Possible values are `username`, `apikey`, or `accesstoken`. | Yes | N/A |
| `user` | The username used to authenticate with Artifactory. Required only when `credentials-type` is set to `username`. | No | N/A |
| `password` | The password used to authenticate with Artifactory. Required only when `credentials-type` is set to `username`. | No | N/A |
| `apikey` | The API key used to authenticate with Artifactory. Required only when `credentials-type` is set to `apikey`. | No | N/A |
| `access-token` | The access token used to authenticate with Artifactory. Required only when `credentials-type` is set to `accesstoken`. | No | N/A |
| `working-directory` | The directory where the jFrog CLI commands will be run. | No | The repository's root directory |

### Repository secrets

You will need the following secrets based on how you authenticate to  Artifactory

| Secret | Description |
| --- | --- |
| `RT_USER` | The username used to authenticate with Artifactory. Required only when `credentials-type` is set to `username`. |
| `RT_PASSWORD` | The password used to authenticate with Artifactory. Required only when `credentials-type` is set to `username`. |
| `RT_APIKEY` | The API key used to authenticate with Artifactory. Required only when `credentials-type` is set to `apikey`. |
| `RT_ACCESSTOKEN` | The access token used to authenticate with Artifactory. Required only when `credentials-type` is set to `accesstoken`. |
| `RT_URL` | The URL to your Artifactory instance. |

### Example

```yaml
on: push
name: Main Workflow
jobs:
  artifactoryUpload:
    name: Upload Trigger
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3.5.2
    - name: build
      run: ./buildmyartifact.sh
    - name: publish to artifactory
      uses: nomadops/artifactory-action@v0
      with:
        url: 'https://company.jfrog.io/'
        credentials type: 'apikey'
        apikey: ${{ secrets.RT_APIKEY }}
        args: args: gp ${{ steps.tag_version.outputs.new_tag }} --server-id rt-server
    - name: search from artifactory
       if: success()
       uses: nomadops/artifactory-action@v0
       with:
         url: ${{ secrets.RT_URL }}
         credentials type: 'username'
         password: ${{ secrets.RT_APIKEY }}
         user: ${{ secrets.RT_USER }}
         args: rt s "go-local/github.com/username/artifactory-demo/@v/${{ steps.tag_version.outputs.new_tag }}.zip" --include-dirs --recursive
```

---

This package was built by [nomadops](https://nomadops.io), a friendly and nomadic consulting company focused on Infrastructure as Code and DevOps solutions.