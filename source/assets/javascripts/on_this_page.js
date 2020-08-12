document.addEventListener("DOMContentLoaded", () => {
  const mainContent = document.querySelector("[data-role~='main-content']")
  const onThisPageBar = document.querySelector("[data-role~='on-this-page']")
  const elementClassList = "my-2 block text-gray-600 no-underline hover:text-blue hover:underline"
  if (mainContent === null || onThisPageBar === null) return

  const headers = mainContent.querySelectorAll("h2, h3")

  console.log(headers.length)

  if(headers.length == 0) {
    const node = document.createElement("li")
    node.textContent = "No subsections"
    node.classList.add("text-gray-600")
    node.classList.add("italic")
    onThisPageBar.appendChild(node)

    return;
  }

  const items = []

  headers.forEach((item) => {
    const headerText = item.querySelector("a")
    const node = document.createElement("li")
    const linkNode = item.querySelector("a").cloneNode(true)
    linkNode.classList = elementClassList

    if (item.tagName === "H3") {
      linkNode.classList.add("ml-2")
    }

    node.appendChild(linkNode)
    onThisPageBar.appendChild(node)
  })
})
