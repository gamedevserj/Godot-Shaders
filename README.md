# Godot shaders

A collection of shaders that I wrote in Unity converted to be used in Godot.

Godot version 3.2.1

## Reflective water

<img src="https://github.com/gamedevserj/Godot-Shaders/blob/master/GithubImages/Water1.png" height="512">

This shader uses SCREEN_TEXTURE to display reflective image to simulate water. Just like the one in Unity it has some limitations. 

Reflection is calculated using object's position, which means if you want to have reflection from top of the object then you need to set Y axis offset to half its height. Visible height of the water object can not exceed the distance to the top of the screen.

Here's an example of the limitations.

<img src="https://github.com/gamedevserj/Godot-Shaders/blob/master/GithubImages/Water1.png" height="256"> <img src="https://github.com/gamedevserj/Godot-Shaders/blob/master/GithubImages/Water2.png" height="256"> <img src="https://github.com/gamedevserj/Godot-Shaders/blob/master/GithubImages/Water3.png" height="256">

In the first image the water starts from the bottom of the screen and goes up to the middle. Which means its visible height is equal  to the distance to the top of the screen. In the second image camera is moved lower, which results in water height being greater than the distance to the top. In the third image the water is way higher than the middle of the screen, but its height is smaller that the distance to the top, so reflections work properly.

The scene contains a script that allows camera to move(WASD keys) and zoom(mouse scroll).

## Impact effect/shockwave

<img src="https://github.com/gamedevserj/Godot-Shaders/blob/master/GithubImages/ImpactEffect.png" height="512">

Impact effect similar to the one produced by a shockwave during explosion. Can be used as a magic spell, terrain deformation effect.

Uses SCREEN_TEXTURE and offsets color using the circular gradient noise as a guide.

Click anywhere in the demo scene to produce the effect.