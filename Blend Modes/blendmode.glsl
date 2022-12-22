#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PI 3.1415926538

uniform sampler2D samplerA; // Source
uniform sampler2D samplerB; // Destination

uniform ivec2 sizeA;
uniform ivec4 rectA;

uniform ivec2 sizeB;
uniform ivec4 rectB;

in vec4 vertTexCoord;

// a = Background / Bottom Layer (x-axis) / Source
// b = Foreground / Top Layer (y-axis) / Destination
vec3 blend(vec3 a, vec3 b)
{

//

#ifdef AVERAGE
	return (a + b) / 2.0;
#endif

#ifdef INTERPOLATION
	return (2.0 - cos(PI * a) - cos(PI * b)) / 4.0;
#endif

#ifdef HARD_MIX
	return vec3(
		(a.x + b.x) < 1.0 ? 0.0 : 1.0,
		(a.y + b.y) < 1.0 ? 0.0 : 1.0,
		(a.z + b.z) < 1.0 ? 0.0 : 1.0
	);
#endif

//

#ifdef ADD
	return a + b;
#endif

#ifdef SUBTRACT
	return a - b;
#endif

#ifdef DIVIDE
	return a / b;
#endif

//

#ifdef MULTIPLY
	return a * b;
#endif

#ifdef SCREEN
	return 1.0 - (1.0 - a) * (1.0 - b);
#endif

#ifdef DARKEN
	return min(a, b);
#endif

#ifdef LIGHTEN
	return max(a, b);
#endif

#ifdef LINEAR_BURN
	return a + b - 1.0;
#endif

#ifdef LINEAR_DODGE
	return a + b;
#endif

#ifdef COLOR_BURN
	return 1.0 - (1.0 - a) / b;
#endif

#ifdef COLOR_DODGE
	return a / (1.0 - b);
#endif

#ifdef SOFT_BURN
	return 1.0 - (1.0 - a) / abs(1.0 - a + b);
#endif

#ifdef SOFT_DODGE
	return a / abs(1.0 + a - b);
#endif

#ifdef GAMMA_DARKER
	return pow(a, 1.0 / b);
#endif

#ifdef GAMMA_LIGHTER
	return 1.0 - pow(1.0 - a, 1.0 / (1.0 - b));
#endif

#ifdef GEOMETRIC_DARKER
	return sqrt(a * b);
#endif

#ifdef GEOMETRIC_LIGHTER
	return 1.0 - sqrt((1.0 - a) * (1.0 - b));
#endif

#ifdef HERONIAN_DARKER
	return (a + sqrt(a * b) + b) / 3.0;
#endif

#ifdef HERONIAN_LIGHTER
	return 1.0 - (2.0 - a + sqrt((1 - a) * (1 - b)) - b) / 3.0;
#endif

#ifdef PYTHAGOREAN_DARKER
	return 1.0 - sqrt(((1.0 - a) * (1.0 - a) + (1.0 - b) * (1.0 - b)) / 2.0);
#endif

#ifdef PYTHAGOREAN_LIGHTER
	return sqrt((a * a + b * b) / 2.0);
#endif

#ifdef ROOT_DARKER
	return 1.0 - sqrt((2.0 - a - b) / 2.0);
#endif

#ifdef ROOT_LIGHTER
	return sqrt((a + b) / 2.0);
#endif

#ifdef FREEZE
	return 1.0 - (1.0 - a) * (1.0 - a)  / b;
#endif

#ifdef REFLECT
	return a * a / (1.0 - b);
#endif

#ifdef HEAT
	return 1.0 - (1.0 - b) * (1.0 - b) / a;
#endif

#ifdef GLOW
	return b * b / (1.0 - a);
#endif

#ifdef SHRINK
	return a + b + a * b - a * a - b * b;
#endif

#ifdef MAGNIFY
	return a * a + b * b - a * b;
#endif

#ifdef ABSORB
	return vec3(
		a.x == b.x ? a.x : (a.x < b.x ? (abs((1.0 - b.x) / (1.0 - a.x) - mod((1.0 - b.x), (1.0 - a.x)))) : (abs((1.0 - a.x) / (1.0 - b.x)) - mod((1.0 - a.x), (1.0 - b.x)))),
		a.y == b.y ? a.y : (a.y < b.y ? (abs((1.0 - b.y) / (1.0 - a.y) - mod((1.0 - b.y), (1.0 - a.y)))) : (abs((1.0 - a.y) / (1.0 - b.y)) - mod((1.0 - a.y), (1.0 - b.y)))),
		a.z == b.z ? a.z : (a.z < b.z ? (abs((1.0 - b.z) / (1.0 - a.z) - mod((1.0 - b.z), (1.0 - a.z)))) : (abs((1.0 - a.z) / (1.0 - b.z)) - mod((1.0 - a.z), (1.0 - b.z))))
	);
#endif

#ifdef EMIT
	return vec3(
		a.x == b.x ? a.x : (a.x < b.x ? (1.0 - abs(a.x / b.x - mod(a.x, b.x))) : (1.0 - abs(b.x / a.x - mod(b.x, a.x)))),
		a.y == b.y ? a.y : (a.y < b.y ? (1.0 - abs(a.y / b.y - mod(a.y, b.y))) : (1.0 - abs(b.y / a.y - mod(b.y, a.y)))),
		a.z == b.z ? a.z : (a.z < b.z ? (1.0 - abs(a.z / b.z - mod(a.z, b.z))) : (1.0 - abs(b.z / a.z - mod(b.z, a.z))))
	);
#endif

//

#ifdef HARD_LIGHT
	return vec3(
		b.x < 0.5 ? 2 * a.x * b.x : (1.0 - 2.0 * (1.0 - a.x) * (1.0 - b.x)),
		b.y < 0.5 ? 2 * a.y * b.y : (1.0 - 2.0 * (1.0 - a.y) * (1.0 - b.y)),
		b.z < 0.5 ? 2 * a.z * b.z : (1.0 - 2.0 * (1.0 - a.z) * (1.0 - b.z))
	);
#endif

#ifdef HARD_LIGHT_SWAP
	return vec3(
		a.x < 0.5 ? 2 * a.x * b.x : (1.0 - 2.0 * (1.0 - a.x) * (1.0 - b.x)),
		a.y < 0.5 ? 2 * a.y * b.y : (1.0 - 2.0 * (1.0 - a.y) * (1.0 - b.y)),
		a.z < 0.5 ? 2 * a.z * b.z : (1.0 - 2.0 * (1.0 - a.z) * (1.0 - b.z))
	);
#endif

#ifdef SOFT_LIGHT
	return 2 * a * b + b * b * (1.0 - 2.0 * a);
#endif

#ifdef SOFT_LIGHT_SWAP
	return 2 * a * b + a * a * (1.0 - 2.0 * b);
#endif

#ifdef PIN_LIGHT
	return vec3(
		b.x < 0.5 ? min(a.x, 2.0 * b.x) : max(a.x, 2.0 * b.x - 1.0),
		b.y < 0.5 ? min(a.y, 2.0 * b.y) : max(a.y, 2.0 * b.y - 1.0),
		b.z < 0.5 ? min(a.z, 2.0 * b.z) : max(a.z, 2.0 * b.z - 1.0)
	);
#endif

#ifdef PIN_LIGHT_SWAP
	return vec3(
		a.x < 0.5 ? min(b.x, 2.0 * a.x) : max(b.x, 2.0 * a.x - 1.0),
		a.y < 0.5 ? min(b.y, 2.0 * a.y) : max(b.y, 2.0 * a.y - 1.0),
		a.z < 0.5 ? min(b.z, 2.0 * a.z) : max(b.z, 2.0 * a.z - 1.0)
	);
#endif

#ifdef LINEAR_LIGHT
	return a + 2.0 * b - 1.0;
#endif

#ifdef LINEAR_LIGHT_SWAP
	return b + 2.0 * a - 1.0;
#endif

#ifdef VIVID_LIGHT
	return vec3(
		b.x < 0.5 ? (1.0 - (1.0 - a.x) / b.x / 2.0) : (a.x / (1.0 - b.x) / 2.0),
		b.y < 0.5 ? (1.0 - (1.0 - a.y) / b.y / 2.0) : (a.y / (1.0 - b.y) / 2.0),
		b.z < 0.5 ? (1.0 - (1.0 - a.z) / b.z / 2.0) : (a.z / (1.0 - b.z) / 2.0)
	);
#endif

#ifdef VIVID_LIGHT_SWAP
	return vec3(
		a.x < 0.5 ? (1.0 - (1.0 - b.x) / a.x / 2.0) : (b.x / (1.0 - a.x) / 2.0),
		a.y < 0.5 ? (1.0 - (1.0 - b.y) / a.y / 2.0) : (b.y / (1.0 - a.y) / 2.0),
		a.z < 0.5 ? (1.0 - (1.0 - b.z) / a.z / 2.0) : (b.z / (1.0 - a.z) / 2.0)
	);
#endif

#ifdef QUADRATIC_LIGHT
	return b * a * a / (1.0 - b) + (1.0 - b) * (1.0 - (1.0 - a) * (1.0 - a) / b);
#endif

#ifdef QUADRATIC_LIGHT_SWAP
	return a * b * b / (1.0 - a) + (1.0 - a) * (1.0 - (1.0 - b) * (1.0 - b) / a);
#endif

#ifdef MODULATED_LIGHT
	return vec3(
		(1.0 - b.x) == a.x ? (1.0 - b.x) : ((1.0 - b.x) > a.x ? abs(b.x / (1.0 - a.x) - mod(b.x, (1.0 - a.x))) : (1.0 - abs((1.0 - b.x) / a.x - mod((1.0 - b.x), a.x)))),
		(1.0 - b.y) == a.y ? (1.0 - b.y) : ((1.0 - b.y) > a.y ? abs(b.y / (1.0 - a.y) - mod(b.y, (1.0 - a.y))) : (1.0 - abs((1.0 - b.y) / a.y - mod((1.0 - b.y), a.y)))),
		(1.0 - b.z) == a.z ? (1.0 - b.z) : ((1.0 - b.z) > a.z ? abs(b.z / (1.0 - a.z) - mod(b.z, (1.0 - a.z))) : (1.0 - abs((1.0 - b.z) / a.z - mod((1.0 - b.z), a.z))))
	);
#endif

#ifdef MODULATED_LIGHT_SWAP
	return vec3(
		(1.0 - a.x) == b.x ? (1.0 - a.x) : ((1.0 - a.x) > b.x ? abs(a.x / (1.0 - b.x) - mod(a.x, (1.0 - b.x))) : (1.0 - abs((1.0 - a.x) / b.x - mod((1.0 - a.x), b.x)))),
		(1.0 - a.y) == b.y ? (1.0 - a.y) : ((1.0 - a.y) > b.y ? abs(a.y / (1.0 - b.y) - mod(a.y, (1.0 - b.y))) : (1.0 - abs((1.0 - a.y) / b.y - mod((1.0 - a.y), b.y)))),
		(1.0 - a.z) == b.z ? (1.0 - a.z) : ((1.0 - a.z) > b.z ? abs(a.z / (1.0 - b.z) - mod(a.z, (1.0 - b.z))) : (1.0 - abs((1.0 - a.z) / b.z - mod((1.0 - a.z), b.z))))
	);
#endif

//

#ifdef DIFFERENCE
	return abs(a - b);
#endif

#ifdef DIFFERENCE_INVERT
	return 1.0 - abs(a - b);
#endif

#ifdef EXCLUSION
	return a + b - 2.0 * a * b;
#endif

#ifdef EXCLUSION_INVERT
	return 1.0 - a - b + 2.0 * a * b;
#endif

#ifdef NEGATION
	return 1.0 - abs(1.0 - a - b);
#endif

#ifdef NEGATION_INVERT
	return abs(1.0 - a - b);
#endif

#ifdef SOLARIZATION
	return 1.0 - sqrt(((2.0 * a - 1.0) * (2.0 * a - 1.0) + (2.0 * b - 1.0) * (2.0 * b - 1.0)) / 2.0);
#endif

#ifdef SOLARIZATION_INVERT
	return sqrt(((2.0 * a - 1.0) * (2.0 * a - 1.0) + (2.0 * b - 1.0) * (2.0 * b - 1.0)) / 2.0);
#endif

}

void main(void)
{
	vec2 st = vertTexCoord.st;

	vec2 pxlA = vec2(rectA.xy) / vec2(sizeA) + st * vec2(rectA.zw) / vec2(sizeA);
	vec2 pxlB = vec2(rectB.xy) / vec2(sizeB) + st * vec2(rectB.zw) / vec2(sizeB);

	vec3 a = texture2D(samplerA, pxlA).rgb;
	vec3 b = texture2D(samplerB, pxlB).rgb;

	gl_FragColor.xyz 	= clamp(blend(a.xyz, b.xyz), 0.0, 1.0);
	gl_FragColor.w 		= 1.0;
}
