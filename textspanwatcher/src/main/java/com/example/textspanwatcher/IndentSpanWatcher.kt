package com.example.textspanwatcher

import android.text.Spannable
import android.util.Log

class IndentSpanWatcher: TextSpanWatcher() {
  override fun onChanged(spanned: Spannable) {
    Log.d("IndentSpanWatcher", "onChanged $spanned")
  }
}