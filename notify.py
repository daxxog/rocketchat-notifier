#!/usr/bin/python3
from os import environ
from pydantic import BaseSettings
import requests


ENV_PREFIX = 'ROCKETCHAT_NOTIFIER_'
class RocketchatNotifierConfig(BaseSettings):
    alias: str = "CICD"
    emoji: str = ":smiley:"
    text: str
    text_from_file: bool = False
    webhook_url: str

    class Config:
        env_prefix = ENV_PREFIX

config: RocketchatNotifierConfig = RocketchatNotifierConfig()


requests.get(config.webhook_url, json={
    "alias": config.alias,
    "emoji": config.emoji,
    "text": open(config.text).read() if config.text_from_file else config.text
})
