# Installation


To get started:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server`


# Running tests 

* `mix test`

# Test coverage 
* `mix test --cover`

# Interacting with the API


**Creating a reaction**
```bash
curl --header "Content-Type: application/json" --request POST --data '{"type": "reaction","action": "add","content_id": "056af828-2efe-4631-8446-c52cabb67367",       "user_id": "9e204fff-9b48-4000-8b21-6cc88be2f01e",       "reaction_type": "fire"   }'  http://localhost:4000/reaction
```

**Deleting a reaction**
```bash
curl --header "Content-Type: application/json" --request POST --data '{"type": "reaction","action": "remove","content_id": "056af828-2efe-4631-8446-c52cabb67367",       "user_id": "9e204fff-9b48-4000-8b21-6cc88be2f01e",       "reaction_type": "fire"   }'  http://localhost:4000/reaction
```


**Getting reaction Counts**
```bash
curl http://localhost:4000reaction_counts/056af828-2efe-4631-8446-c52cabb67367
```


