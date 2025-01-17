ITKDoxygen
==========

[![][doxygen-img]][doxygen-link] [![][deployment-img]][deployment-link] [![][build-docker-img]][build-docker-link] [![][rtd-latest-img]][rtd-latest-link]

[doxygen-img]: https://github.com/InsightSoftwareConsortium/ITKDoxygen/actions/workflows/Doxygen.yml/badge.svg
[doxygen-link]: https://github.com/InsightSoftwareConsortium/ITKDoxygen/actions/workflows/Doxygen.yml

[deployment-img]: https://github.com/InsightSoftwareConsortium/ITKDoxygen/actions/workflows/pages/pages-build-deployment/badge.svg
[deployment-link]: https://insightsoftwareconsortium.github.io/ITKDoxygen/

[build-docker-img]: https://github.com/InsightSoftwareConsortium/ITKDoxygen/actions/workflows/build-docker-image.yml/badge.svg
[build-docker-link]: https://github.com/InsightSoftwareConsortium/ITKDoxygen/actions/workflows/build-docker-image.yml

[rtd-latest-img]: https://readthedocs.org/projects/itkdoxygen/badge/?version=latest
[rtd-latest-link]: https://app.readthedocs.org/projects/itkdoxygen/

Overview
--------

This Dockerfile has been created to facilitate the creation of
[ITK](https://github.com/InsightSoftwareConsortium/ITK)
[Doxygen](https://doxygen.nl/)
documentation in a reproducible way.

The documentation is built nightly on the current/latest ITK commit,
and deployed to GitHub pages at: https://insightsoftwareconsortium.github.io/ITKDoxygen/
and to ReadTheDocs at: https://docs.itk.org/projects/doxygen/

To create the documentation locally, run the following commands:

### 1. Clone the ITKDoxygen Repository

### 2. Build the Docker Image
```shell
docker build . -f Dockerfile -t itk-doxygen
```

### 3. Export TAG Environment Variable
The `TAG` environment variable is used to specify a filename for the tarballs 
to be copied from the Docker container to your local working directory (see 
[step 5](#5-copy-the-doxygen-documentation)).
Useful for naming multiple versions of the documentation.

Here we have set it to *alpha*, but you may change it as needed.
```shell
export TAG=alpha
```

### 4. Run the Docker Container
#### Option 1: Using the Latest ITK Repository
```shell
docker run --env TAG --name itk-dox itk-doxygen
```

#### Option 2: Using a Local ITK Repository
If you want to build documentation from a local ITK repository, 
remove the `readonly` parameter from the mount command and 
specify an absolute path to the aforementioned repository.
```shell
docker run \
  --env TAG \
  --mount type=bind,source=/path/to/your/clone,destination=/work/ITK,readonly \
  --name itk-dox itk-doxygen
```
> **Note:** Both these commands may take a while to complete

### 5. Copy the Doxygen Documentation

The following commands will copy the tarballs from the
Docker container to your local working directory.
```shell
docker cp itk-dox:/ITKDoxygen.tar.gz ITKDoxygen${TAG:+-${TAG}}.tar.gz
docker cp itk-dox:/ITKDoxygenXML.tar.gz ITKDoxygenXML${TAG:+-${TAG}}.tar.gz

# Remove the Docker container after copying the tarballs
docker rm itk-dox
```

### 6. Extract the Doxygen Documentation
Untar these tarballs to extract and verify the Doxygen documentation. 
The `ITKDoxygen` tarball contains the HTML documentation,
while the `ITKDoxygenXML` tarball contains the XML documentation.

```shell
tar -xzf ITKDoxygen${TAG:+-${TAG}}.tar.gz
tar -xzf ITKDoxygenXML${TAG:+-${TAG}}.tar.gz
```

You may now view the Doxygen documentation by opening the `html/index.html` file.
