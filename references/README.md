# Design Reference Knowledge

This is the always-on index for a reusable design reference library. It is suitable for websites, product interfaces, game UI, dashboards, and interactive experiences.

## Purpose

Store source-traceable design references separately from project-specific decisions. A consuming agent should load this file first, classify the task, and then load only the matching domain and website files.

## Source Snapshot

- Source: [Google Sheet](https://docs.google.com/spreadsheets/d/1yA5qV20l1xqyNYyxtVltw9ccNR5iTKMYUI0lQCLg-WA/edit?gid=1649646686#gid=1649646686)
- Tabs: `Inspire-Reference`, `Component-Layout`, `Animation-Motion`, `Shaders`, `Particles`
- Schema: `Source`, `Link`, `Use`, `Notes` (the final two fields are translated from the Thai sheet fields)
- Non-empty rows represented: 13
- Independent website inspection: none during this conversion

## Domains

| Domain | Load when the task concerns | File |
| --- | --- | --- |
| Visual inspiration | General visual direction or browsing inspiration | [visual-inspiration.md](domains/visual-inspiration.md) |
| Component and layout | Components, sections, layout, UI structure, or product/dashboard UI | [component-layout.md](domains/component-layout.md) |
| Animation and motion | Entrance, timeline, stagger, scroll, hover, or micro-interaction motion | [animation-motion.md](domains/animation-motion.md) |
| Shaders | Shader, WebGL, or animated background effects | [shaders.md](domains/shaders.md) |
| Particles | Particle backgrounds, hero accents, or ambient effects | [particles.md](domains/particles.md) |

## Semantic Routing

Classify the request by intent, not by filename:

| Task signal | Primary domain | Optional website references |
| --- | --- | --- |
| Choose a visual direction or inspiration source | Visual inspiration | Any source selected from the domain |
| Build or compare a component, section, hero, card, background, hover state, or dashboard UI | Component and layout | Aceternity, Magic UI, 21st.dev, Origin UI, daisyUI |
| Design entrance, timeline, stagger, scroll, hover, or micro-interaction motion | Animation and motion | Anime.js, Aceternity, 21st.dev |
| Explore shader, WebGL, or animated background ideas | Shaders | 21st.dev Shader UI, Origin UI |
| Explore particle background or ambient accent ideas | Particles | Casberry Particles, Aceternity |
| Study one named source | The source's website file | Its linked domain files |

When a task spans domains, load the smallest set that covers the requested behavior. For example, an animated hero may need `component-layout.md`, `animation-motion.md`, and optionally `shaders.md` or `particles.md` only when those effects are requested.

## Website References

- [Magic UI](websites/magicui.md)
- [Aceternity](websites/aceternity.md)
- [daisyUI](websites/daisyui.md)
- [21st.dev](websites/21st-dev.md)
- [Origin UI](websites/origin-ui.md)
- [Anime.js](websites/anime-js.md)
- [21st.dev Shader UI](websites/21st-dev-shader-ui.md)
- [Casberry Particles](websites/casberry-particles.md)

## Provenance and Limits

Every website file preserves its source URL and the originating sheet tab. `Priority` and `Status` are not present in the source sheet, so they are not inferred. Descriptions are translated from the sheet and are not claims about independently inspected websites.

Project-specific priorities, visual decisions, and implementation constraints belong in the consuming project, not in this library.
