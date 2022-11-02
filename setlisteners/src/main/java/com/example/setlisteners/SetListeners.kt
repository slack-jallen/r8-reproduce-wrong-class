package com.example.setlisteners

import com.example.textextensions.addTextSpanWatcher

import android.widget.EditText
import com.example.textspanwatcher.BeginningFormatEnabledWatcher
import com.example.textspanwatcher.IndentSpanWatcher

class SetListeners(val text: EditText) {

  private val quoteAllTheThings = QuoteAllTheThings(true)

  fun setListeners() {
    if (quoteAllTheThings.m1) {
      text.addTextSpanWatcher(IndentSpanWatcher())
      text.addTextSpanWatcher(BeginningFormatEnabledWatcher())
    }
  }
}