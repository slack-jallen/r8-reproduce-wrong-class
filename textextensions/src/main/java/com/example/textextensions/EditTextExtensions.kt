package com.example.textextensions

import android.util.Log
import android.widget.EditText
import com.example.textspanwatcher.TextSpanWatcher

fun EditText.addTextSpanWatcher(watcher: TextSpanWatcher) {
  val existingWatcher =
    this.text
      .getSpans(0, this.length(), watcher::class.java)
      // Check for exact class in case inheritance is used in the future.
      .firstOrNull { it::class.java == watcher::class.java }
  if (existingWatcher != null) {
    // Currently there only ever needs to be one TextSpanWatcher of each type. This avoids the
    // inefficiency of having
    // duplicates.
    Log.d("addTextSpanWatcher","Using existing watcher, $existingWatcher, instead of adding new one, $watcher")
    existingWatcher.afterTextChanged(this.text)
  } else {
    Log.d("addTextSpanWatcher","NOT Using existing watcher, $existingWatcher, instead of adding new one, $watcher")
    this.addTextChangedListener(watcher)
    watcher.afterTextChanged(this.text)
  }
}
