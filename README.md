# This is old and will not be updated, please use [bradlyq's stable player display](https://github.com/bradleyq/stable_player_display) instead
# player_skin_shader

A resource pack that uses a shader (rendertype_entity_translucent) to change the UV of player heads to the different body parts. This also contains models to change player heads to the shapes and sizes of each body part, and some textures to prevent the shader from affecting other entities.

The shader works based on render order. The order of body parts is:
1. head
2. body
3. left arm
4. right arm
5. left leg
6. right leg

Summon the different entities for each part in that order, and it will work. If one of these is not rendered, all after it will be off and it will look odd.

# models

The models are for the right arm of an armor stand. If you summon an armor stand riding and aec with the models in the right arm, then here are the offsets needed to make a player:
1. head: ^0 ^-0.40675 ^0
2. body: ^0 ^-1.10987 ^0
3. left arm: ^0.11133 ^-1.10987 ^-0.00586
4. right arm: ^-0.11133 ^-1.10987 ^-0.00586
5. left leg: ^0.29297 ^-0.52394 ^0
6. right leg: ^-0.29297 ^-0.52394 ^0

With the new display entities, the models should not be needed. Scale numbers can be found in the model files.

# textures

The textures are in place because the things that use them are rendered using the same shader as player heads, and the shader cannot tell and will change the UV like a player head. They have been scaled up from 64x64 to 128x128 so the shader ignores them and does not move the UV.

# known issues

* When only some of the heads are rendered, the rest use the wrong UV. This shouldn't be an issue if you use the new display entities, as they don't cull.
* Placed player heads have UVs changed when they shouldn't.

Not necassarily an issue, but it would be nicer to use one entity and one model. This is not possible, even with something like objmc.
