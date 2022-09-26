# robo-run

Coded via Processing 4.0b1
Tested on a Windows 10 NVIDIA RTX 2080Ti device

Note:

- This is a simple "runner" type game that resets upon completion
- There are multiple different obstacles with different functionalities
- The wood tree stumps collide with the user and block movement unless they are jumped over. It has 2 textures applied.
- The frog is an interesting geometry that moves and hops like a frog does. When they are collided with, they animate
  into a "dead frog" and provide the user with an extra jump.
- The water is hazardous, and sends the user back to the start upon collision. It must be jumped over. It is textured.
- The rubber ducky is the goal point, sending the user back to the start, but in a good way (marking completion).

Jump using SPACE.
Camera Modes can be toggled between First/Third Person using ENTER.
Clicking and dragging the mouse while in First Person will allow for free camera movement until released.

There are also extra systems - Environmental Skyboxing/Particle Systems, and Shading/Lighting. This exists in the form
of a "Night" mode which can be toggled on and off using 'Q' - where it begins snowing, the textures of the ground and
skybox change, and there is now lighting effects including a directional light which is more noticeable if you use freelook.

All textures are downloaded from https://3djungle.net/.
The frog shape is from https://free3d.com/.
The duck shape is from Coltyn Stone-Lamontagne via the CSSA Discord, who designed the model in Blender.
