package net.bbmsoft.fx.osk.impl.components

import java.util.Locale
import java.util.function.Consumer
import javafx.scene.control.Control
import net.bbmsoft.fx.osk.OskFx
import net.bbmsoft.fx.osk.impl.components.skin.KeyButtonSkin
import net.bbmsoft.fxtended.annotations.binding.BindableProperty
import net.bbmsoft.fxtended.annotations.binding.Styleable
import net.bbmsoft.fxtended.annotations.css.PseudoClasses
import net.bbmsoft.keyboard.KeyCode
import net.bbmsoft.keyboard.KeyMap

import static extension net.bbmsoft.fxtended.extensions.BindingOperatorExtensions.*

@PseudoClasses('letter')
class KeyButton extends Control {

	@Styleable('-key-size-factor')
	@BindableProperty double sizeFactor = 1.0

	@Styleable('-key-height-factor')
	@BindableProperty double heightFactor = 1.0

	@Styleable('-key-base-size')
	@BindableProperty double baseSize = 64.0

	@BindableProperty KeyCode code

	@BindableProperty String text

	@BindableProperty OskFx osk

	@BindableProperty Consumer<KeyButton> onPressed
	@BindableProperty Consumer<KeyButton> onReleased

	@Styleable ('-touch-up-delay')
	@BindableProperty int touchUpDelay = 200

	@BindableProperty KeyMap keyMap

	new() {

		this.styleClass.addAll('button', 'key-button')

		this.codeProperty >> [obs, o, n | keyChanged(o, n)]

		this.focusTraversable = false
		this.cache = true
		this.visible = false

		this.keyMapProperty >> [extension it |
			this.pseudoClassStateChanged(PSEUDO_CLASS_LETTER, this.code.isLetter)
		]
	}

	override protected createDefaultSkin() {
		new KeyButtonSkin(this)
	}

	private def keyChanged(KeyCode oldCode, KeyCode newCode) {

		if(oldCode !== null) styleClass.remove(oldCode.toString.toLowerCase(Locale.US))
		if(newCode !== null) styleClass.add(newCode.toString.toLowerCase(Locale.US))

		this.visible = newCode !== null
		if(this.keyMap !== null) {
			this.pseudoClassStateChanged(PSEUDO_CLASS_LETTER, this.keyMap.isLetter(newCode))
		}
	}

}
