const path = require("path")
const { IgnorePlugin } = require("webpack")
const { CleanWebpackPlugin } = require("clean-webpack-plugin");

module.exports = {
  entry: [
    "./source/assets/main.js"
  ],
  output: {
    filename: "bundle.js",
    path: path.resolve(__dirname, ".tmp", "dist"),
    publicPath: "/"
  },
  plugins: [
    new CleanWebpackPlugin(),
  ],
  module: {
    rules: [
      {
        test: /\.css$/,
        use: [
          "style-loader",
          "css-loader",
        ],
      },
      {
        test: /\.s[ac]ss$/i,
        use: [
          "style-loader",
          "css-loader",
          "sass-loader",
        ],
      },
      {
        test: /\.(png|svg|jpg|gif)$/,
        use: [
          "file-loader",
        ],
      },
      {
        test: /\.(woff|woff2|eot|ttf|otf)$/,
        use: [
          "file-loader",
        ],
      }
    ],
  },
}
