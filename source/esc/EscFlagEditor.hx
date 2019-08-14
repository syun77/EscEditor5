package esc;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * フラグ編集
 */
class EscFlagEditor extends FlxSpriteGroup {
    static inline var FONT_SIZE:Int = 14;
    static inline var WIDTH:Int = 16;
    static inline var HEIGHT:Int = 16;

    var _isEnd:Bool = false;
    var _sprHorizontal:FlxSprite;
    var _sprVertical:FlxSprite;
    var _cursor:Int = 0;
    var _txtCaption:FlxText;
    var _textSpr:FlxSprite;
    var _txt0:FlxText;
    var _txt1:FlxText;

    /**
     * コンストラクタ
     */
    public function new() {
        super();

        // 撰択カーソル
        _sprHorizontal = new FlxSprite().makeGraphic(WIDTH*11, HEIGHT, FlxColor.WHITE);
        _sprVertical = new FlxSprite().makeGraphic(WIDTH, HEIGHT*11, FlxColor.WHITE);
        this.add(_sprHorizontal);
        this.add(_sprVertical);

        _textSpr = new FlxSprite().makeGraphic(11 * WIDTH, 11 * HEIGHT, FlxColor.TRANSPARENT);
        {
            _txt0 = new FlxText(0, 0, 0, "0", FONT_SIZE);
            _txt1 = new FlxText(0, 0, 0, "1", FONT_SIZE);

            // 全てのフラグを更新
            _updateAllFlags(0);
        }
        this.add(_textSpr);

        _txtCaption = new FlxText(8, HEIGHT*12, 0, 16);
        this.add(_txtCaption);
    }

    public function isEnd():Bool {
        return _isEnd;
    }

    /**
     * 更新
     */
    public override function update(elapsed:Float):Void {
        super.update(elapsed);

        // カーソルを更新
        _updateCursor();

        if(FlxG.keys.justPressed.Z) {
            // フラグのOn/Off切り替え
            var flag = EscGlobal.flagCheck(_cursor) == false;
            EscGlobal.flagSet(_cursor, flag);

            // フラグ更新
            _updateFlag(_cursor);
        }

        if(FlxG.keys.justPressed.X) {
            // 終了
            _isEnd = true;
        }
    }

    /**
     * カーソルの更新
     */
    function _updateCursor():Void {
        var digitX = _cursor%10;
        var digitY = Math.floor(_cursor/10)%10;
        {
            _sprVertical.x = (digitX + 1) * WIDTH + x - 2;
            _sprHorizontal.y = (digitY + 1) * HEIGHT + y + 2;
        }

        if(FlxG.keys.justPressed.LEFT) {
            digitX--;
            if(digitX < 0) {
                digitX = 9;
            }
        }
        if(FlxG.keys.justPressed.RIGHT) {
            digitX++;
            if(digitX > 9) {
                digitX = 0;
            }
        }
        if(FlxG.keys.justPressed.UP) {
            digitY--;
            if(digitY < 0) {
                digitY = 9;
            }
        }
        if(FlxG.keys.justPressed.DOWN) {
            digitY++;
            if(digitY > 9) {
                digitY = 0;
            }
        }

        _cursor = (digitY * 10) + digitX;

        {
            var str = '${_cursor}: ';
            var color = FlxColor.BLUE;
            if(EscGlobal.flagCheck(_cursor)) {
                str += "On";
                _txtCaption.color = FlxColor.RED;
                color = FlxColor.PURPLE;
            }
            else {
                str += "Off";
                _txtCaption.color = FlxColor.LIME;
            }
            _txtCaption.text = str;
            _sprHorizontal.color = color;
            _sprVertical.color = color;
        }
    }

    /**
     * フラグを全て更新
     */
    function _updateAllFlags(ofs:Int):Void {
        var pt = new Point();
        var rect = new Rectangle();
        rect.x = 0;
        rect.y = 0;

        // ヘッダ文字
        var txtHeader = new FlxText(0, 0, 0, FONT_SIZE-2);
        txtHeader.color = FlxColor.fromRGB(0xA0, 0xA0, 0xA0, 0xFF);
        for(i in 0...10) {
            txtHeader.text = '${i}';
            pt.x = WIDTH * (i + 1);
            pt.y = 0;
            rect.width = txtHeader.width;
            rect.height = txtHeader.height;
            _textSpr.pixels.copyPixels(txtHeader.pixels, rect, pt);
        }
        for(j in 0...10) {
            txtHeader.text = '${j}';
            pt.x = 0;
            pt.y = HEIGHT * (j + 1);
            rect.width = txtHeader.width;
            rect.height = txtHeader.height;
            _textSpr.pixels.copyPixels(txtHeader.pixels, rect, pt);
        }

        // 本体
        for(j in 0...10) {
            for(i in 0...10) {
                pt.x = WIDTH * (i + 1);
                pt.y = HEIGHT * (j + 1);
                var idx = ofs + (i + (10 * j));
                var txt = _txt0;
                if(EscGlobal.flagCheck(idx)) {
                    txt = _txt1;
                }
                rect.width = txt.width;
                rect.height = txt.height;
                _textSpr.pixels.copyPixels(txt.pixels, rect, pt);
            }
        }
        _textSpr.dirty = true;
        _textSpr.updateFramePixels();
    }

    function _updateFlag(idx:Int):Void {
        var flag = EscGlobal.flagCheck(idx);
        var txt = _txt0;
        if(flag) {
            txt = _txt1;
        }
        var i = _cursor % 10 + 1;
        var j = Std.int(_cursor / 10) + 1;
        var pt = new Point(i * WIDTH, j * HEIGHT);
        var rect = new Rectangle();
        rect.x = 0;
        rect.y = 0;
        rect.width = txt.width;
        rect.height = txt.height;
        _textSpr.pixels.copyPixels(txt.pixels, rect, pt);
        _textSpr.dirty = true;
        _textSpr.updateFramePixels();
    }
}