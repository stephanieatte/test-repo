steps:
  - label: ":golang: :package:"
    commands: 
       - "mkdir output"
       - "cd output"
       - "mkdir BOO_artifacts"
       - "cd BOO_artifacts"
       - "touch log.txt"
    env:
     JOB_NAME: "BOO"
    artifact_paths: "output/\${JOB_NAME}_artifacts/*"
    plugins:
      - docker#v3.3.0:
          image: "golang:1.11"
