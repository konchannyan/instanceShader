Shader "JackyGun/instanceShader"
{
	Properties
	{
	}

	SubShader
	{
		Tags{ "Queue" = "Transparent" "RenderType" = "Opaque" }

		Pass
		{
			CGPROGRAM

			#pragma target 5.0
			#pragma vertex mainVS
			#pragma hull mainHS
			#pragma domain mainDS
			#pragma geometry mainGS
			#pragma fragment mainFS

			// Geometry Shader [TESS * TESS * GS_INSTANCE]
			// input mesh topology : point
			#define TESS 65
			#define GS_INSTANCE 32

			// Structure
			struct VS_IN
			{
			};

			struct VS_OUT
			{
			};

			struct CONSTANT_HS_OUT
			{
				float e[4] : SV_TessFactor;
				float i[2] : SV_InsideTessFactor;
			};

			struct HS_OUT
			{
			};

			struct DS_OUT
			{
				uint pid : PID;
			};

			struct GS_OUT
			{
				float4 vertex : SV_POSITION;
			};

			// Main
			VS_OUT mainVS(VS_IN In)
			{
				VS_OUT Out;
				return Out;
			}

			CONSTANT_HS_OUT mainCHS()
			{
				CONSTANT_HS_OUT Out;
				Out.e[0] = Out.e[1] = Out.e[2] = Out.e[3] = Out.i[0] = Out.i[1] = TESS - 1;
				return Out;
			}

			[domain("quad")]
			[partitioning("integer")]
			[outputtopology("point")]
			[outputcontrolpoints(1)]
			[patchconstantfunc("mainCHS")]
			HS_OUT mainHS(InputPatch<VS_OUT, 4> In)
			{
			}
			
			[domain("quad")]
			DS_OUT mainDS(CONSTANT_HS_OUT In, const OutputPatch<HS_OUT, 4> patch, float2 uv : SV_DomainLocation)
			{
				DS_OUT Out;
				Out.pid = (uint)(round(uv.x * (TESS - 1))) + ((uint)(round(uv.y * (TESS - 1))) * TESS);
				return Out;
			}

			[instance(GS_INSTANCE)]
			[maxvertexcount(24)]
			void mainGS(point DS_OUT input[1], inout TriangleStream<GS_OUT> outStream, uint gsid : SV_GSInstanceID)
			{
				GS_OUT o;

				// id : [0] - [TESS * TESS * GS_INSTANCE - 1]
				uint id = gsid + GS_INSTANCE * input[0].pid;

				// test : draw 135,200 cube, 1,622,400 polygon
				uint xid = id % 368;
				uint zid = id / 368;
				float xd = -100 * 0.5f + 100 * 0.5f / 368 + 100 * xid / 368;
				float zd = -100 * 0.5f + 100 * 0.5f / 368 + 100 * zid / 368;

				float4 wpos0 = UnityObjectToClipPos(float4(float3(-1, +1, +1) * 0.1f + float3(xd, 0, zd), 1));
				float4 wpos1 = UnityObjectToClipPos(float4(float3(+1, +1, +1) * 0.1f + float3(xd, 0, zd), 1));
				float4 wpos2 = UnityObjectToClipPos(float4(float3(-1, +1, -1) * 0.1f + float3(xd, 0, zd), 1));
				float4 wpos3 = UnityObjectToClipPos(float4(float3(+1, +1, -1) * 0.1f + float3(xd, 0, zd), 1));
				float4 wpos4 = UnityObjectToClipPos(float4(float3(-1, -1, +1) * 0.1f + float3(xd, 0, zd), 1));
				float4 wpos5 = UnityObjectToClipPos(float4(float3(+1, -1, +1) * 0.1f + float3(xd, 0, zd), 1));
				float4 wpos6 = UnityObjectToClipPos(float4(float3(-1, -1, -1) * 0.1f + float3(xd, 0, zd), 1));
				float4 wpos7 = UnityObjectToClipPos(float4(float3(+1, -1, -1) * 0.1f + float3(xd, 0, zd), 1));

				o.vertex = wpos0;
				outStream.Append(o);
				o.vertex = wpos1;
				outStream.Append(o);
				o.vertex = wpos2;
				outStream.Append(o);
				o.vertex = wpos3;
				outStream.Append(o);
				outStream.RestartStrip();

				o.vertex = wpos4;
				outStream.Append(o);
				o.vertex = wpos6;
				outStream.Append(o);
				o.vertex = wpos5;
				outStream.Append(o);
				o.vertex = wpos7;
				outStream.Append(o);
				outStream.RestartStrip();

				o.vertex = wpos0;
				outStream.Append(o);
				o.vertex = wpos2;
				outStream.Append(o);
				o.vertex = wpos4;
				outStream.Append(o);
				o.vertex = wpos6;
				outStream.Append(o);
				outStream.RestartStrip();

				o.vertex = wpos3;
				outStream.Append(o);
				o.vertex = wpos1;
				outStream.Append(o);
				o.vertex = wpos7;
				outStream.Append(o);
				o.vertex = wpos5;
				outStream.Append(o);
				outStream.RestartStrip();

				o.vertex = wpos1;
				outStream.Append(o);
				o.vertex = wpos0;
				outStream.Append(o);
				o.vertex = wpos5;
				outStream.Append(o);
				o.vertex = wpos4;
				outStream.Append(o);
				outStream.RestartStrip();

				o.vertex = wpos2;
				outStream.Append(o);
				o.vertex = wpos3;
				outStream.Append(o);
				o.vertex = wpos6;
				outStream.Append(o);
				o.vertex = wpos7;
				outStream.Append(o);
				outStream.RestartStrip();

			}

			float4 mainFS(GS_OUT In) : SV_Target
			{
				return float4(0, 1, 1, 1);
			}
			ENDCG
		}
	}
}
