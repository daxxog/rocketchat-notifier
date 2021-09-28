rocketchat-notifier
===================
A simple python script and docker container for pushing notifications to rocketchat in drone pipelines.


### Example Usage
```yaml
---
kind: pipeline
type: kubernetes
name: test
steps:
  - name: ok
    image: debian:bullseye
    commands:
      - echo ok
  - name: report success
    image: daxxog/rocketchat-notifier:1
    environment:
      ROCKETCHAT_NOTIFIER_WEBHOOK_URL: https://chat.mycoolcompany.example.com/hooks/<some secret values>
      ROCKETCHAT_NOTIFIER_ALIAS: DRONE
      ROCKETCHAT_NOTIFIER_EMOJI: ':k8s:'
      ROCKETCHAT_NOTIFIER_TEXT: hello !
    when:
      status:
        - success
```
