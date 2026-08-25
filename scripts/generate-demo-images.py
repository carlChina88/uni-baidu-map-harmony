#!/usr/bin/env python3
"""Generate the README's AI mock phone screenshots.

These are intentionally labelled as concept previews in README.md. They are not
real HarmonyOS device captures and must not be used as verification evidence.
"""

from __future__ import annotations

import os
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "docs" / "images"
OUTPUT.mkdir(parents=True, exist_ok=True)

WIDTH = 360
HEIGHT = 760
SCALE = 2

REGULAR_FONT_CANDIDATES = (
    "/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc",
    "/usr/share/fonts/opentype/noto/NotoSansCJKsc-Regular.otf",
    "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
)
BOLD_FONT_CANDIDATES = (
    "/usr/share/fonts/opentype/noto/NotoSansCJK-Bold.ttc",
    "/usr/share/fonts/opentype/noto/NotoSansCJKsc-Bold.otf",
    "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
)


def first_existing(paths: tuple[str, ...]) -> str:
    for path in paths:
        if os.path.exists(path):
            return path
    raise FileNotFoundError(f"No usable font found in: {paths}")


REGULAR_FONT = first_existing(REGULAR_FONT_CANDIDATES)
BOLD_FONT = first_existing(BOLD_FONT_CANDIDATES)


def font(size: int, bold: bool = False) -> ImageFont.FreeTypeFont:
    return ImageFont.truetype(BOLD_FONT if bold else REGULAR_FONT, size * SCALE)


def rounded(draw: ImageDraw.ImageDraw, box: tuple[int, int, int, int], radius: int,
            fill: str | None, outline: str | None = None, width: int = 1) -> None:
    draw.rounded_rectangle(
        tuple(value * SCALE for value in box),
        radius=radius * SCALE,
        fill=fill,
        outline=outline,
        width=width * SCALE,
    )


def draw_line(draw: ImageDraw.ImageDraw, points: tuple[int, ...], fill: str,
              width: int = 1) -> None:
    draw.line(tuple(value * SCALE for value in points), fill=fill,
              width=width * SCALE, joint="curve")


def draw_text(draw: ImageDraw.ImageDraw, point: tuple[int, int], value: str,
              size: int, fill: str = "#111111", bold: bool = False,
              anchor: str | None = None) -> None:
    draw.text((point[0] * SCALE, point[1] * SCALE), value,
              font=font(size, bold), fill=fill, anchor=anchor)


def draw_polygon(draw: ImageDraw.ImageDraw, points: list[tuple[int, int]],
                 fill: str) -> None:
    draw.polygon([(x * SCALE, y * SCALE) for x, y in points], fill=fill)


def draw_circle(draw: ImageDraw.ImageDraw, center: tuple[int, int], radius: int,
                fill: str | None, outline: str | None = None,
                width: int = 1) -> None:
    x, y = center
    draw.ellipse(
        ((x - radius) * SCALE, (y - radius) * SCALE,
         (x + radius) * SCALE, (y + radius) * SCALE),
        fill=fill,
        outline=outline,
        width=width * SCALE,
    )


def phone_base(title: str, subtitle: str, time: str) -> tuple[Image.Image, ImageDraw.ImageDraw]:
    image = Image.new("RGB", (WIDTH * SCALE, HEIGHT * SCALE), "white")
    draw = ImageDraw.Draw(image)

    rounded(draw, (4, 4, 356, 756), 36, "#d8dadd")
    rounded(draw, (6, 4, 354, 754), 36, "#111316")
    rounded(draw, (12, 10, 348, 748), 30, "#ffffff")

    draw_text(draw, (28, 25), time, 12, "#101214", True, "lm")
    draw_circle(draw, (180, 23), 5, "#0d1117")
    for index, bar_height in enumerate((4, 7, 10, 13)):
        x = 284 + index * 5
        draw.rectangle((x * SCALE, (27 - bar_height) * SCALE,
                        (x + 3) * SCALE, 27 * SCALE), fill="#111111")
    draw.arc((258 * SCALE, 16 * SCALE, 278 * SCALE, 34 * SCALE),
             200, 340, fill="#111111", width=SCALE)
    draw.arc((262 * SCALE, 20 * SCALE, 274 * SCALE, 32 * SCALE),
             200, 340, fill="#111111", width=SCALE)
    draw_circle(draw, (268, 27), 1, "#111111")
    rounded(draw, (311, 18, 331, 29), 3, None, "#111111")
    draw.rectangle((313 * SCALE, 20 * SCALE, 328 * SCALE, 27 * SCALE),
                   fill="#111111")

    draw.rectangle((14 * SCALE, 42 * SCALE, 346 * SCALE, 96 * SCALE),
                   fill="#ffffff")
    draw_text(draw, (180, 68), "uni-baidu-map-harmony 示例", 17,
              "#101214", True, "mm")
    draw.line((14 * SCALE, 96 * SCALE, 346 * SCALE, 96 * SCALE),
              fill="#e8eaed", width=SCALE)

    draw.rectangle((14 * SCALE, 96 * SCALE, 346 * SCALE, 146 * SCALE),
                   fill="#f7f8fa")
    draw_text(draw, (28, 113), title, 14, "#111827", True, "lm")
    draw_text(draw, (28, 134), subtitle, 10, "#4b5563", False, "lm")

    draw.rectangle((14 * SCALE, 654 * SCALE, 346 * SCALE, 710 * SCALE),
                   fill="#ffffff")
    draw.line((14 * SCALE, 654 * SCALE, 346 * SCALE, 654 * SCALE),
              fill="#e5e7eb", width=SCALE)
    draw.rectangle((14 * SCALE, 710 * SCALE, 346 * SCALE, 748 * SCALE),
                   fill="#ffffff")
    draw.line((14 * SCALE, 710 * SCALE, 346 * SCALE, 710 * SCALE),
              fill="#f1f2f4", width=SCALE)

    draw_line(draw, (42, 729, 49, 722, 42, 715), "#111111")
    for x in (180, 205, 230):
        draw_circle(draw, (x, 728), 2, "#111111")
    draw_circle(draw, (314, 728), 8, None, "#111111")
    draw_circle(draw, (314, 728), 2, "#111111")
    return image, draw


def map_view(draw: ImageDraw.ImageDraw, interaction: bool = False) -> None:
    x0, y0, x1, y1 = 14, 146, 346, 654
    draw.rectangle((x0 * SCALE, y0 * SCALE, x1 * SCALE, y1 * SCALE),
                   fill="#f4f7f7")
    draw_polygon(draw, [(286, 510), (346, 470), (346, 654),
                        (264, 654), (275, 600)], "#d9efff")
    draw_polygon(draw, [(240, 430), (322, 400), (346, 460),
                        (286, 510), (274, 590), (222, 548)], "#dff2df")
    draw_polygon(draw, [(40, 500), (125, 470), (142, 580),
                        (60, 620)], "#e7f5e7")

    for x in (44, 78, 112, 148, 186, 222, 258, 298, 330):
        draw_line(draw, (x, y0, x - 18, y1), "#d6dadd")
    for y in (174, 210, 248, 286, 325, 365, 405, 448, 493, 542, 594, 630):
        draw_line(draw, (x0, y, x1, y - 10), "#d6dadd")

    roads = (
        (14, 270, 346, 250),
        (20, 438, 346, 420),
        (118, 146, 138, 654),
        (14, 560, 346, 515),
        (220, 146, 210, 654),
    )
    for road in roads:
        draw_line(draw, road, "#ffffff", 7)
        draw_line(draw, road, "#a9d8bd", 2)
    draw_line(draw, (14, 326, 346, 312), "#fff9d9", 8)
    draw_line(draw, (14, 326, 346, 312), "#e1c76e", 2)

    labels = (
        (54, 254, "科技园"),
        (106, 343, "深圳大学"),
        (238, 363, "深圳软件园"),
        (239, 492, "南山公园"),
        (49, 418, "深南大道"),
        (145, 309, "高新南"),
        (98, 606, "深圳湾创业广场"),
    )
    for x, y, label in labels:
        draw_text(draw, (x, y), label, 9, "#496277", False, "mm")
    draw_text(draw, (180, 318), "深南大道", 10, "#334155", True, "mm")

    draw_line(draw, (28, 625, 78, 625), "#111111", 2)
    draw_text(draw, (29, 615), "500米" if interaction else "200米",
              8, "#111111", False, "lm")
    draw_text(draw, (28, 642), "Baidu Maps SDK", 8,
              "#2563eb", True, "lm")
    draw.rectangle((14 * SCALE, 146 * SCALE, 346 * SCALE, 654 * SCALE),
                   outline="#e6e8ea", width=SCALE)


def marker_pin(draw: ImageDraw.ImageDraw, x: int, y: int) -> None:
    draw_circle(draw, (x, y - 8), 10, "#e53935")
    draw_polygon(draw, [(x - 7, y - 2), (x + 7, y - 2), (x, y + 14)],
                 "#e53935")
    draw_circle(draw, (x, y - 8), 3, "#ffffff")


def save(image: Image.Image, filename: str) -> None:
    final = image.resize((WIDTH, HEIGHT), Image.Resampling.LANCZOS)
    final = final.quantize(
        colors=128,
        method=Image.Quantize.MEDIANCUT,
        dither=Image.Dither.FLOYDSTEINBERG,
    )
    final.save(OUTPUT / filename, optimize=True)


def generate() -> None:
    image, draw = phone_base(
        "基础地图（Basic Map）",
        "地图初始化完成，展示中心点与缩放级别",
        "10:45",
    )
    map_view(draw)
    draw_text(draw, (28, 682), "中心点：22.533271, 113.942190",
              10, "#111827", False, "lm")
    draw_text(draw, (332, 682), "缩放：15", 10,
              "#111827", False, "rm")
    save(image, "basic-map.png")

    image, draw = phone_base(
        "Marker 与 PopView",
        "单个 Marker 与原生信息气泡",
        "10:46",
    )
    map_view(draw)
    marker_pin(draw, 184, 434)
    rounded(draw, (72, 220, 288, 338), 12, "#ffffff", "#dfe3e7")
    draw_polygon(draw, [(166, 338), (184, 352), (202, 338)], "#ffffff")
    draw_text(draw, (92, 244), "百度大厦", 14, "#111827", True, "lm")
    draw_text(draw, (92, 270), "距离 123.5 米", 10, "#6b7280", False, "lm")
    draw_text(draw, (92, 296), "广东省深圳市南山区科技路1001号",
              9, "#6b7280", False, "lm")
    draw_text(draw, (28, 682), "中心点：22.533271, 113.942190",
              10, "#111827", False, "lm")
    draw_text(draw, (332, 682), "缩放：17", 10,
              "#111827", False, "rm")
    save(image, "marker-popview.png")

    image, draw = phone_base(
        "地图交互（Map Interaction）",
        "拖动地图后触发 centerchange 事件",
        "10:47",
    )
    map_view(draw, interaction=True)
    rounded(draw, (86, 172, 274, 226), 10, "#24272b")
    draw_text(draw, (180, 190), "中心点已更新", 12,
              "#ffffff", True, "mm")
    draw_text(draw, (180, 210), "(22.528276, 113.935544)",
              10, "#ffffff", False, "mm")
    draw_text(draw, (28, 682), "中心点：22.528276, 113.935544",
              10, "#111827", False, "lm")
    draw_text(draw, (332, 682), "缩放：14", 10,
              "#111827", False, "rm")
    save(image, "map-interaction.png")

    for legacy in OUTPUT.glob("*.svg"):
        legacy.unlink()


if __name__ == "__main__":
    generate()
