# Look into multi-stage builds so we can do the build from within a dockerfile rather than manually doing so or requiring dotnet on the host
# See http://blog.alexellis.io/mutli-stage-docker-builds/
FROM       microsoft/dotnet:2.0-runtime

RUN        useradd -Ms /bin/bash -c 'dotnet app user' dotnet
USER       dotnet

ARG        REPO_BRANCH
ARG        REPO_VERSION
ARG        VERSION=1.0

LABEL      app=webapi-demo
LABEL      version=$VERSION
LABEL      repo-branch=$REPO_BRANCH
LABEL      repo-version=$REPO_VERSION

WORKDIR    /app
COPY       bin .

EXPOSE     5000

ENTRYPOINT ["dotnet", "webapi.dll"]
