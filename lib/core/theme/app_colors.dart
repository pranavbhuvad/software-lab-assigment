import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Figma Color Styles ─────────────────────────────────────────
  static const Color primary     = Color(0xFFD4704A); // slide 1 bg / CTA brown
  static const Color secondary   = Color(0xFFE8B84B); // slide 3 bg / CTA yellow
  static const Color tertiary    = Color(0xFF5A8C5A); // slide 1 illustration green

  static const Color primaryText = Color(0xFF1A1A1A); // Primary Text
  static const Color white       = Color(0xFFFFFFFF); // White
  static const Color lightText   = Color(0xFFB0B0B0); // Light Text

  static const Color blue        = Color(0xFF0047FF); // #0047FF
  static const Color green       = Color(0xFF00CB14); // #00CB14

  // ── Onboarding slide backgrounds ──────────────────────────────
  static const Color slideGreen  = Color(0xFF5A8C5A); // Quality   — tertiary
  static const Color slideBrown  = Color(0xFFD4704A); // Convenient — primary
  static const Color slideYellow = Color(0xFFE8B84B); // Local     — secondary

  // ── CTA buttons per slide ──────────────────────────────────────
  static const Color ctaGreen    = Color.fromRGBO(94,162,95,1); // Quality CTA   — #00CB14
  static const Color ctaBrown    = Color(0xFFD4704A); // Convenient CTA — primary
  static const Color ctaYellow   = Color(0xFFE8B84B); // Local CTA     — secondary

  // ── App scaffold background ────────────────────────────────────
  static const Color background  = Color(0xFFF5F0EB);

  // ── Text ───────────────────────────────────────────────────────
  static const Color textPrimary   = primaryText;
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color loginText     = lightText;

  // ── Dot indicator ─────────────────────────────────────────────
  static const Color dotActive   = primaryText;
  static const Color dotInactive = Color(0xFFCCCCCC);
}