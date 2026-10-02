shader_type canvas_item;
render_mode unshaded;

// Use a screen texture with mipmaps enabled.
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

// Define the size (in screen pixels) for each square block.
// Smaller values yield smaller blocks.
uniform float pixel_size : hint_range(1.0, 100.0) = 8.0;

// Define how many neighboring blocks to average for the blur.
// A kernel_radius of 1 results in a 3x3 neighborhood.
uniform int kernel_radius : hint_range(0, 5) = 1;

// LOD parameter for mipmap level sampling (0.0 means the base level).
uniform float lod : hint_range(0.0, 5.0) = 0.0;

void fragment() {
    // Get the viewport size (in pixels) from the screen texture.
    vec2 viewport = vec2(textureSize(screen_texture, 0));

    // Convert the normalized SCREEN_UV coordinate to screen-space (in pixels).
    vec2 screen_pos = SCREEN_UV * viewport;

    // Snap the screen position to the grid defined by pixel_size.
    // This ensures each sample falls at the center of a square block.
    vec2 grid_pos = floor(screen_pos / pixel_size) * pixel_size + pixel_size * 0.5;

    // Convert the snapped position back into normalized UV coordinates.
    vec2 pixelated_uv = grid_pos / viewport;

    // Sample the screen texture over a box (with a size determined by kernel_radius)
    // and use the provided LOD parameter when sampling.
    vec4 color_sum = vec4(0.0);
    float total = 0.0;
    for (int i = -kernel_radius; i <= kernel_radius; i++){
        for (int j = -kernel_radius; j <= kernel_radius; j++){
            // Calculate the offset in UV space based on pixel_size.
            vec2 offset = vec2(float(i), float(j)) * (pixel_size / viewport);
            // Sample the texture at the offset position using the LOD parameter.
            color_sum += texture(screen_texture, pixelated_uv + offset, lod);
            total += 1.0;
        }
    }
    // Average the accumulated color samples.
    COLOR = color_sum / total;
}