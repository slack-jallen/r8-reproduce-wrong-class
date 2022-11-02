package com.example.myapplication

import android.text.Spannable
import android.util.Log

class BeginningFormatEnabledWatcher: TextSpanWatcher() {
  override fun onChanged(spanned: Spannable) {
    Log.d("BeginningFormatEnabledWatcher","onChanged $spanned")
  }
}