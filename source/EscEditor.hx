package;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;

class EscEditor extends FlxSpriteGroup {
    var _loader:EscLoader;
    var _bg:FlxSprite;
    var _objs:Array<FlxSprite>;
    var _selobj:FlxSprite = null;
    var _selframe:FlxSprite = null;
    var _txts:Array<FlxText>;

    public function new() {
        super();

        _loader = new EscLoader("assets/data/layout.xml");
        _txts = new Array<FlxText>();

        // 背景の読み込み
        {
            var bg = _loader.bg;
            var file = "assets/images/" + _loader.bg.image;
            _bg = new FlxSprite(bg.x, bg.y, file);
            bg.setText(_addText());
            this.add(_bg);
        }

        // 選択枠
        _selframe = new FlxSprite(0, 0);
        _selframe.visible = false;
        this.add(_selframe);

        // 配置オブジェクト
        _objs = new Array<FlxSprite>();
        for(obj in _loader.objs) {
            var file = "assets/images/" + obj.image;
            var spr = new FlxSprite(obj.x, obj.y, file);
            obj.setText(_addText());
            _objs.push(spr);
        }

        for(obj in _objs) {
            this.add(obj);
        }

        // ヘルプテキスト
        for(txt in _txts) {
            this.add(txt);
        }
    }

    function _addText():FlxText {
        var length:Int = _txts.length;
        var x:Float = 8;
        var y:Float = 8 + (length * 24);
        var txt = new FlxText(x, y);
        var size:Int = 20;
        txt.setFormat(null, size);
        _txts.push(txt);
        return txt;
    }

	/**
	 * クリックしたオブジェクトを取得
	 */
    function _clickObj():FlxSprite {
		for(obj in _objs) {
			var x:Float = FlxG.mouse.x;
			var y:Float = FlxG.mouse.y;
			var x1:Float = obj.x;
			var y1:Float = obj.y;
			var x2:Float = obj.x + obj.width;
			var y2:Float = obj.y + obj.height;
			if(x1 < x && x < x2) {
				if(y1 < y && y < y2) {
					return obj;
				}
			}
		}

		return null;
    }

    public override function update(elapsed:Float):Void {
        super.update(elapsed);

		if(FlxG.keys.justPressed.Z) {
			// テキストに出力する
			trace("\n" + _loader.build());
		}

		// 撰択しているオブジェクトと位置を合わせる
		for(i in 0..._objs.length) {
			var obj = _objs[i];
			_loader.objs[i].x = obj.x;
			_loader.objs[i].y = obj.y;
		}

		var str:String = "";
		_txts[0].text = _loader.bg.getString();
		for(i in 0...2) {
			str = "";
			var obj = _loader.objs[i];
			_txts[i + 1].text = obj.getString();
		}

		// クリックしたオブジェクトを取得する
		if(FlxG.mouse.justPressed) {
			_selobj = _clickObj();
			if(_selobj != null) {
				var width:Float = _selobj.width + 4;
				var height:Float = _selobj.height + 4;
				_selframe.makeGraphic(Std.int(width), Std.int(height), FlxColor.RED);
			}
		}

		_selframe.visible = false;
		if(FlxG.mouse.pressed) {
			if(_selobj != null) {
				// マウスの位置に移動
				_selobj.x = FlxG.mouse.x;
				_selobj.y = FlxG.mouse.y;
				// 枠を表示
				_selframe.visible = true;
				_selframe.x = _selobj.x - 2;
				_selframe.y = _selobj.y - 2;
			}
		}
    }

    /**
     * デバッグ表示の更新
     */
    function _updateDebug():Void {

    }

    public override function draw():Void {
        super.draw();
    }
}