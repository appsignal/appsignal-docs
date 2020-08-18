import "./jquery"
import Cookies from "./js.cookie"
import "./navigation_store"
import "./dl_header"
import { loadAnalyticsScripts } from "./analytics"

$(document).ready(function() {
  var navigationElement = $("#navigation");
  var navigationElements = $(".mod-side_nav h2");

  // Make sure the section of the current page is open
  var currentMenu = navigationElement.find("a.active").parents(".section").find("h2").data("menu");
  if(currentMenu) {
    NavigationStore.set(currentMenu, true);
  }

  // Toggle open state on navigation heading click
  navigationElements.on("click", function() {
    var element = $(this);
    var state = !element.hasClass("open");

    element.toggleClass("open", state);
    NavigationStore.set(element.data("menu"), state);
  });

  // Open those elements that have been open by the user.
  navigationElements.each(function() {
    var element = $(this);
    if(NavigationStore.fetch(element.data("menu"))) {
      element.addClass("open");
    }
  });

  window.NAVIGATION_SCROLL_TOP_KEY = "navigation_scroll_top";
  function storeScrollPosition(position) {
    localStorage.setItem(window.NAVIGATION_SCROLL_TOP_KEY, position);
  }
  function getScrollPosition() {
    return localStorage.getItem(window.NAVIGATION_SCROLL_TOP_KEY);
  }

  // Save scroll position
  $("#navigation").on("scroll", function(e) {
    storeScrollPosition($(this).scrollTop());
  });
  navigationElement.scrollTop(getScrollPosition());

  let userSignedIn = Cookies.get("appsignal_signed_in") == "true";
  if(userSignedIn) {
    $(".logged-in").show();
    $(".logged-out").hide();
  }

  if (userSignedIn || Cookies.get("cookie_consent") == "true") {
    $(".mod-cookies").hide();
    loadAnalyticsScripts();
  }

  // Track pageview
  if (window.location.host == "docs.appsignal.com") {
    var tracker_src = "https://appsignal.com/ident.gif?page=" +
      encodeURI("docs: " + window.location.pathname) +
      "&" +
      window.location.search.slice(1, window.location.search.length);
    var img = document.createElement("img");
    img.src = tracker_src;
    img.height = "1";
    img.width = "1";
    img.style = "display:none;";
    document.body.appendChild(img);
  }

  $(".mod-cookies .accept_link").click(function(e) {
    e.preventDefault();
    $(".mod-cookies").hide();

    var consent_src = "https://appsignal.com/cookie_consent.gif";
    var img = document.createElement("img");
    img.src = consent_src;
    img.height = "1";
    img.width = "1";
    img.style = "display:none;";
    document.body.appendChild(img);

    loadAnalyticsScripts();
  })

  $('[data-role="accordion-head"]').click(function(event) {
    event.preventDefault()

    var accordion = $(event.target).parents('[data-role="accordion"]').first()
    var accordion_head = accordion.children('[data-role="accordion-head"]')
    var accordion_body = accordion.children('[data-role="accordion-body"]')

    debugger

    // Toggle accordion head
    var accordion_head_active_classes = accordion_head.attr("data-accordion-head-active-classes")
    accordion_head.toggleClass(accordion_head_active_classes)

    // Toggle accordion body
    accordion_body.toggle()
  })
});
