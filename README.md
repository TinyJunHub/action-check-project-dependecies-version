# action-check-project-dependencies-version V1.2.6
This action checks your project's snapshot dependencies.

# Usage
```yaml
- uses: TinyJunHub/action-check-project-dependencies-version@v1.2.6
  with:
    # Project folder path. For example, ./pom.xml
    # Default: './'
    file-path: ''
    # The suffix regex rule of filtering the project's dependencies version
    # For example, version `0.0.1-SNAPSHOT` will be filtered when the value is `SNAPSHOT`
    # Default: 'SNAPSHOT'
    suffix-regex: ''
    # Project build type like service-maven, service-gradle and android-gradle.
    # Default: 'service-maven'
    project-type: ''
    # The name of main subproject which you want to check like `app` in Android
    # Default: ''
    main-subproject-name: ''
```

# Scenarios
+ [Check service project with maven](https://github.com/TinyJunHub/action-check-project-dependencies-version#Check-service-project-with-maven)
+ [Check service project with gradle](https://github.com/TinyJunHub/action-check-project-dependencies-version#Check-service-project-with-gradle)
+ [Check android project with gradle](https://github.com/TinyJunHub/action-check-project-dependencies-version#Check-service-project-with-gradle)

## Check project repository with maven
```yaml
  - name: check snapshot dependencies
    uses: TinyJunHub/action-check-project-dependencies-version@v1
```

## Check service project with gradle
```yaml
  - name: check snapshot dependencies
    uses: TinyJunHub/action-check-project-dependencies-version@v1
    with:
      project-type: 'service-gradle'
```

## Check android project with gradle
```yaml
  - name: check snapshot dependencies
    uses: TinyJunHub/action-check-project-dependencies-version@v1
    with:
      project-type: 'android-gradle'
      main-subproject-name: 'app'
```
