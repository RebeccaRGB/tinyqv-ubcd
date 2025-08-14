<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

The peripheral index is the number TinyQV will use to select your peripheral.  You will pick a free
slot when raising the pull request against the main TinyQV repository, and can fill this in then.  You
also need to set this value as the PERIPHERAL_NUM in your test script.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

# Universal Segmented LED Driver

Author: Rebecca G. Bettencourt

Peripheral index: 23

## What it does

This peripheral can be used to drive a variety of segmented LED displays using a variety of encodings:

* BCD on a seven segment display with a wide variety of options for customizing the appearance of digits
* ASCII on a seven segment display with two different “fonts”
* BCD on a [Cistercian numeral](https://en.wikipedia.org/wiki/Cistercian_numerals) display
* BCV (binary-coded *vigesimal*) on a [Kaktovik numeral](https://en.wikipedia.org/wiki/Kaktovik_numerals) display

### BCD mode

This mode displays a decimal digit in BCD on a standard seven segment display. There are registers that affect the display of the digits 6, 7, and 9, and eight different options for handling out-of-range values. These registers allow this peripheral to match the behavior of just about any BCD to seven segment decoder, making it *universal*.

![](ubcd.svg)

The registers used in this mode are:

* **/AL** - Active low. If 1, outputs will be HIGH when lit. If 0, outputs will be LOW when lit.
* **/BI** - Blanking input. If 0, all segments will be blank regardless of other inputs, including **/LT**.
* **/LT** - Lamp test. When **/BI** is 1 and **/LT** is 0, all segments will be lit.
* **/RBI** - Ripple blanking input. If the BCD value is zero and **/RBI** is 0, all segments will be blank.
* **V0**, **V1**, **V2** - Selects the output when the BCD value is out of range.
* **X6** - When 1, the extra segment **a** will be lit on the digit 6.
* **X7** - When 1, the extra segment **f** will be lit on the digit 7.
* **X9** - When 1, the extra segment **d** will be lit on the digit 9.
* **/RBO** - Ripple blanking output. 1 when BCD value is nonzero or **/RBI** is 1.

### ASCII mode

This mode displays an ASCII character on a standard seven segment display. Like with the BCD mode, there are registers that affect the display of the digits 6, 7, and 9. There are also two choices of “font” and the option to display lowercase letters as uppercase or as lowercase.

![](ascii-f0.svg)

![](ascii-f1.svg)

The registers used in this mode are:

* **/AL** - Active low. If 1, outputs will be HIGH when lit. If 0, outputs will be LOW when lit.
* **/BI** - Blanking input. If 0, all segments will be blank regardless of other inputs.
* **FS** - Font select. Selects one of two “fonts.”
* **LC** - Lower case. If 0, lowercase letters will appear as uppercase.
* **X6** - When 1, the extra segment **a** will be lit on the digit 6.
* **X7** - When 1, the extra segment **f** will be lit on the digit 7.
* **X9** - When 1, the extra segment **d** will be lit on the digit 9.
* **/LTR** - Letter. 0 when the input is a letter (A...Z or a...z).

### Cistercian mode

This mode displays a decimal digit in BCD on one quarter of the segmented display for [Cistercian numerals](https://en.wikipedia.org/wiki/Cistercian_numerals) shown below.

![](cistercian-display.svg)

The patterns produced for each input value are shown below.

![](cistercian-decoder.svg)

The registers used in this mode are:

* **/AL** - Active low. If 1, outputs will be HIGH when lit. If 0, outputs will be LOW when lit.
* **/BI** - Blanking input. If 0, all segments will be blank regardless of other inputs, including **/LT**.
* **/LT** - Lamp test. When **/BI** is 1 and **/LT** is 0, all segments will be lit.

### Kaktovik mode

This mode displays a *vigesimal* (base 20) digit in BCV (binary-coded vigesimal) on the segmented display for [Kaktovik numerals](https://en.wikipedia.org/wiki/Kaktovik_numerals) shown below.

![](kaktovik-display.svg)

The patterns produced for each input value are shown below.

![](kaktovik-decoder.svg)

The registers used in this mode are:

* **/AL** - Active low. If 1, outputs will be HIGH when lit. If 0, outputs will be LOW when lit.
* **/BI** - Blanking input. If 0, all segments will be blank regardless of other inputs, including **/LT**.
* **/LT** - Lamp test. When **/BI** is 1 and **/LT** is 0, all segments will be lit.
* **/RBI** - Ripple blanking input. If the BCV value is zero and **/RBI** is 0, all segments will be blank.
* **/VBI** - Overflow blanking input. If the BCV value is out of range and **/VBI** is 0, all segments will be blank.
* **/RBO** - Ripple blanking output. 1 when BCV value is nonzero or **/RBI** is 1.
* **V** - Overflow. 1 when BCV value is out of range (greater than or equal to 20).

## Register map

| Address | Name  | Access | Description                                                         |
|---------|-------|--------|---------------------------------------------------------------------|
| 0x00    | DATA  | R/W    | The value to display in BCD, ASCII, or BCV format.
| 0x01    | DCR   | R/W    | Display control register. Contains **/AL**, **/BI**, **/LT**, **/VBI**, **/RBI**.
| 0x02    | VAR   | R/W    | Variant register. Controls the display of digits, letters, and out-of-range values.
| 0x03    | PCR   | R/W    | Peripheral control register. Selects the mode of operation.
| 0x04    | OUT   | R      | Output register. Returns the state of the segmented display.
| 0x05    | SR    | R      | Status register. Contains **/LTR**, **V**, **/RBO**.

### Display control register format

Used for address 0x01.

| Bit | Mask | Name | Description |
|-----|------|------|-------------|
| 0   | 0x01 | /AL  | Active low. If 1, outputs will be HIGH when lit. If 0, outputs will be LOW when lit.
| 1   | 0x02 | /BI  | Blanking input. If 0, all segments will be blank regardless of other inputs, including **/LT**.
| 2   | 0x04 | /LT  | Lamp test. When **/BI** is 1 and **/LT** is 0, all segments will be lit.

## External hardware

For the BCD and ASCII modes, a standard seven-segment display is used.

For the Cistercian mode, a segmented display like the one below is used. There are design files for such a display [here](https://github.com/RebeccaRGB/buck/tree/main/cistercian-display).

![](cistercian-display.svg)

For the Kaktovik mode, a segmented display like the one below is used. There are design files for such a display [here](https://github.com/RebeccaRGB/buck/tree/main/kaktovik-display).

![](kaktovik-display.svg)
