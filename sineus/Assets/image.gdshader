shader_type canvas_item;

// Основная тайл-текстура
uniform sampler2D tile_tex : source_color;
uniform vec2 tile_scale = vec2(4.0, 4.0);
uniform vec2 tile_offset = vec2(0.0, 0.0);
// Текстура шума
uniform sampler2D noise_tex : source_color;
uniform float noise_strength = 0.5; // степень влияния нойза
uniform vec2 noise_scale = vec2(1.0, 1.0); // масштаб шума

// Смещение нойз текстуры
uniform vec2 noise_offset = vec2(0.0, 0.0);

void fragment() {
    // базовые UV для тайла
    vec2 tiled_uv = fract(UV * tile_scale + tile_offset);
    vec4 base_color = texture(tile_tex, tiled_uv);

    // нойз по отдельному UV с учётом смещения и тайлинга
    vec2 noise_uv = fract(UV * noise_scale + noise_offset);
    float noise_value = texture(noise_tex, noise_uv).r; // берём яркость канала

    // добавляем нойз как модификатор яркости
    vec3 final_color = base_color.rgb * (1.0 - noise_strength + noise_value * noise_strength);

    COLOR = vec4(final_color, base_color.a);
}
