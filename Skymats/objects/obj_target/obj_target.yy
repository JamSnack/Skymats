{
  "spriteId": {
    "name": "spr_target",
    "path": "sprites/spr_target/spr_target.yy",
  },
  "solid": false,
  "visible": true,
  "managed": true,
  "spriteMaskId": null,
  "persistent": false,
  "parentObjectId": {
    "name": "ENEMY",
    "path": "objects/ENEMY/ENEMY.yy",
  },
  "physicsObject": false,
  "physicsSensor": false,
  "physicsShape": 1,
  "physicsGroup": 1,
  "physicsDensity": 0.5,
  "physicsRestitution": 0.1,
  "physicsLinearDamping": 0.1,
  "physicsAngularDamping": 0.1,
  "physicsFriction": 0.2,
  "physicsStartAwake": true,
  "physicsKinematic": false,
  "physicsShapePoints": [],
  "eventList": [
    {"isDnD":false,"eventNum":0,"eventType":3,"collisionObjectId":null,"resourceVersion":"1.0","name":"","tags":[],"resourceType":"GMEvent",},
    {"isDnD":false,"eventNum":0,"eventType":8,"collisionObjectId":null,"resourceVersion":"1.0","name":"","tags":[],"resourceType":"GMEvent",},
    {"isDnD":false,"eventNum":0,"eventType":0,"collisionObjectId":null,"resourceVersion":"1.0","name":"","tags":[],"resourceType":"GMEvent",},
    {"isDnD":false,"eventNum":0,"eventType":1,"collisionObjectId":null,"resourceVersion":"1.0","name":"","tags":[],"resourceType":"GMEvent",},
  ],
  "properties": [
    {"varType":0,"value":"10","rangeEnabled":false,"rangeMin":0.0,"rangeMax":10.0,"listItems":[],"multiselect":false,"filters":[],"resourceVersion":"1.0","name":"max_hp","tags":[],"resourceType":"GMObjectProperty",},
    {"varType":0,"value":"max_hp","rangeEnabled":false,"rangeMin":0.0,"rangeMax":10.0,"listItems":[],"multiselect":false,"filters":[],"resourceVersion":"1.0","name":"hp","tags":[],"resourceType":"GMObjectProperty",},
    {"varType":0,"value":"4","rangeEnabled":false,"rangeMin":0.0,"rangeMax":10.0,"listItems":[],"multiselect":false,"filters":[],"resourceVersion":"1.0","name":"knockback","tags":[],"resourceType":"GMObjectProperty",},
    {"varType":0,"value":"0","rangeEnabled":false,"rangeMin":0.0,"rangeMax":10.0,"listItems":[],"multiselect":false,"filters":[],"resourceVersion":"1.0","name":"damage","tags":[],"resourceType":"GMObjectProperty",},
    {"varType":1,"value":"1","rangeEnabled":false,"rangeMin":0.0,"rangeMax":10.0,"listItems":[],"multiselect":false,"filters":[],"resourceVersion":"1.0","name":"ground_direction","tags":[],"resourceType":"GMObjectProperty",},
  ],
  "overriddenProperties": [
    {"propertyId":{"name":"bounciness","path":"objects/ENTITY/ENTITY.yy",},"objectId":{"name":"ENTITY","path":"objects/ENTITY/ENTITY.yy",},"value":"0","resourceVersion":"1.0","name":"","tags":[],"resourceType":"GMOverriddenProperty",},
    {"propertyId":{"name":"item_to_drop","path":"objects/ENEMY/ENEMY.yy",},"objectId":{"name":"ENEMY","path":"objects/ENEMY/ENEMY.yy",},"value":"ITEM_ID.last","resourceVersion":"1.0","name":"","tags":[],"resourceType":"GMOverriddenProperty",},
    {"propertyId":{"name":"max_hp","path":"objects/ENEMY/ENEMY.yy",},"objectId":{"name":"ENEMY","path":"objects/ENEMY/ENEMY.yy",},"value":"1 + instance_number(obj_target)","resourceVersion":"1.0","name":"","tags":[],"resourceType":"GMOverriddenProperty",},
    {"propertyId":{"name":"hp","path":"objects/ENEMY/ENEMY.yy",},"objectId":{"name":"ENEMY","path":"objects/ENEMY/ENEMY.yy",},"value":"max_hp","resourceVersion":"1.0","name":"","tags":[],"resourceType":"GMOverriddenProperty",},
  ],
  "parent": {
    "name": "Enemies",
    "path": "folders/Objects/Enemies.yy",
  },
  "resourceVersion": "1.0",
  "name": "obj_target",
  "tags": [],
  "resourceType": "GMObject",
}