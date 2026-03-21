import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Figma Color Styles ─────────────────────────────────────────
  static const Color primary     = Color.fromRGBO(213, 113, 91, 1);
  static const Color secondary   = Color(0xFFE8B84B);
  static const Color tertiary    = Color(0xFF5A8C5A);

  static const Color primaryText = Color.fromRGBO(38, 28, 18, 1);
  static const Color white       = Color(0xFFFFFFFF);
  static const Color lightText   = Color(0xFFB0B0B0);

  static const Color blue        = Color(0xFF0047FF);
  static const Color green       = Color(0xFF00CB14);

  // ── Onboarding slide backgrounds ──────────────────────────────
  static const Color slideGreen  = Color(0xFF5A8C5A);
  static const Color slideBrown  = Color(0xFFD4704A);
  static const Color slideYellow = Color(0xFFE8B84B);

  // ── CTA buttons per slide ──────────────────────────────────────
  static const Color ctaGreen    = Color.fromRGBO(94, 162, 95, 1);
  static const Color ctaBrown    = Color(0xFFD4704A);
  static const Color ctaYellow   = Color(0xFFE8B84B);

  // ── App scaffold background ────────────────────────────────────
  static const Color background  = Color(0xFFF5F0EB);

  // ── Text ───────────────────────────────────────────────────────
  static const Color textPrimary   = primaryText;
  static const Color textSecondary = Color.fromRGBO(0,0,0,0.3);
  static const Color loginText     = lightText;

  // ── Dot indicator ─────────────────────────────────────────────
  static const Color dotActive   = primaryText;
  static const Color dotInactive = Color(0xFFCCCCCC);

  static const Color black = Color.fromRGBO(0, 0, 0, 1);

  // ── Auth / Signup ──────────────────────────────────────────────
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color inputFill     = Color(0xFFF5F5F5);
  static const Color divider       = Color(0xFFE8E8E8);
  static const Color textHint      = Color(0xFFBBBBBB);
  static const Color error         = Color(0xFFE53935);
  static const Color success       = Color(0xFF43A047);
  static const Color primaryLight  = Color(0xFFF4A88A);
  static const Color primarySoft   = Color(0xFFFDE8E1);
  static const Color selectedSlot  = primary;
  static const Color unselectedSlot = Color(0xFFF0F0F0);
}