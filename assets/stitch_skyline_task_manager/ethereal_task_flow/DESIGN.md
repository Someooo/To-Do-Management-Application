---
name: Ethereal Task Flow
colors:
  surface: '#f9f9fd'
  surface-dim: '#d9dade'
  surface-bright: '#f9f9fd'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3f7'
  surface-container: '#eeedf2'
  surface-container-high: '#e8e8ec'
  surface-container-highest: '#e2e2e6'
  on-surface: '#1a1c1f'
  on-surface-variant: '#404752'
  inverse-surface: '#2f3034'
  inverse-on-surface: '#f0f0f4'
  outline: '#717783'
  outline-variant: '#c0c7d4'
  surface-tint: '#0060a9'
  primary: '#0060a9'
  on-primary: '#ffffff'
  primary-container: '#4da3ff'
  on-primary-container: '#003866'
  inverse-primary: '#a2c9ff'
  secondary: '#4f606e'
  on-secondary: '#ffffff'
  secondary-container: '#d3e5f6'
  on-secondary-container: '#556675'
  tertiary: '#5b5f63'
  on-tertiary: '#ffffff'
  tertiary-container: '#9ca0a5'
  on-tertiary-container: '#33373b'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d3e4ff'
  primary-fixed-dim: '#a2c9ff'
  on-primary-fixed: '#001c38'
  on-primary-fixed-variant: '#004881'
  secondary-fixed: '#d3e5f6'
  secondary-fixed-dim: '#b7c9d9'
  on-secondary-fixed: '#0c1d29'
  on-secondary-fixed-variant: '#384956'
  tertiary-fixed: '#dfe3e8'
  tertiary-fixed-dim: '#c3c7cc'
  on-tertiary-fixed: '#181c20'
  on-tertiary-fixed-variant: '#43474b'
  background: '#f9f9fd'
  on-background: '#1a1c1f'
  surface-variant: '#e2e2e6'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
    letterSpacing: -0.01em
  title-md:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 8px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  gutter: 16px
  margin-mobile: 20px
---

## Brand & Style
The design system embodies a premium, high-performance aesthetic tailored for personal and professional productivity. It balances the structural efficiency of enterprise SaaS tools like Linear with the approachable elegance of high-end lifestyle apps. 

The visual narrative is defined by **Soft Minimalism**. It avoids visual clutter by prioritizing intentional whitespace and subtle tonal shifts over heavy borders or loud decorative elements. The emotional response should be one of "calm focus"—reducing the anxiety typically associated with long task lists through a spacious, airy, and organized interface.

## Colors
The palette is rooted in a "Sky and Slate" concept. In **Light Mode**, we use a pure white background with subtle #F7FAFF surface overlays to create soft "containers" without needing strokes. The primary blue is vibrant but soft, ensuring high legibility for interactive elements.

In **Dark Mode**, the system transitions to a deep charcoal/navy (#0B0E14). Surface containers move to a slightly lighter #161B22. This maintains the premium SaaS look, avoiding pure black to prevent harsh contrast and "smearing" on OLED screens. Text colors should scale from pure white for headings to a muted blue-grey for secondary metadata to maintain visual hierarchy.

## Typography
This design system utilizes **Inter** for all roles to achieve a systematic, utilitarian, and clean appearance. 

- **Headlines:** Use tighter letter spacing and semi-bold weights to create a strong anchor for page sections.
- **Body:** Standardized at 16px for optimal readability on mobile devices.
- **Labels:** Used for task categories, tags, and timestamps. These use uppercase styling and increased letter spacing to differentiate them from actionable body text.
- **Hierarchy:** Use color (Primary Text vs. Secondary Text) as the primary driver of hierarchy rather than just font size.

## Layout & Spacing
Following a fluid grid philosophy with a 4px baseline. On mobile, the standard side margin is 20px to allow for a "spacious" feel that differentiates the app from standard utility tools.

- **Vertical Rhythm:** Group related items (like a task title and its subtasks) using `sm` (12px) spacing. Group unrelated sections (like "Today" vs "Upcoming") using `xl` (32px) spacing.
- **Touch Targets:** All interactive elements (checkboxes, icons) must maintain a minimum 44x44px invisible tap area regardless of their visual size.

## Elevation & Depth
In alignment with Material 3, depth is expressed through **Tonal Layers** rather than heavy shadows. 

- **Level 0 (Base):** The main background.
- **Level 1 (Cards/Sheet):** Uses a subtle background color shift (Surface Light/Dark) with a very soft, diffused shadow: `0px 4px 12px rgba(0, 0, 0, 0.05)`.
- **Level 2 (Modals/Popups):** Higher contrast with a slightly more pronounced shadow to indicate it is "closer" to the user.

In Dark Mode, elevation is communicated primarily through lighter surface tones; shadows should be near-black and very subtle.

## Shapes
The shape language is friendly and modern. The standard `rounded-md` is 16px, used for primary action buttons and task cards. `rounded-lg` (20px) is reserved for large containers like bottom sheets or modal cards. 

This high degree of roundedness contrasts with the sharp, precise typography of Inter, creating a balance between "professional tool" and "approachable app."

## Components
- **Buttons:** Primary buttons use a solid #4DA3FF background with white text and 16px corner radius. Secondary buttons should use the accent #DCEEFF with primary blue text.
- **Task Cards:** No borders. Use the Surface color (#F7FAFF) for the card background. Padding should be `md` (16px) on all sides.
- **Checkboxes:** When checked, they should animate to a solid #4DA3FF circle with a white checkmark. When unchecked, use a 2px stroke in a light grey-blue.
- **Inputs:** Use the "Filled" Material 3 style. The field background should be #F7FAFF with a bottom indicator line that glows Primary Blue on focus.
- **Chips/Tags:** Small 12px font, 100px border radius (pill), and subtle backgrounds. Use the status colors (Success/Warning) at 10% opacity for the background and 100% opacity for the text.
- **Floating Action Button (FAB):** A large 56x56px circular button with the primary blue background, placed in the bottom right, with a soft elevation shadow.