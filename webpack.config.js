const path = require("path")
const BrowserSyncPlugin = require("browser-sync-webpack-plugin")
const HtmlWebpackPlugin = require("html-webpack-plugin")
// TODO: Use in production
// const MiniCssExtractPlugin = require("mini-css-extract-plugin")

module.exports = {
  // default:
  // entry: './src/index.js',
  output: {
    path: path.resolve(__dirname, "public")
  },
  module: {
    rules: [
      {
        test: /\.scss$/,
        use: [
          "style-loader",
          "css-loader",
          "sass-loader"
        ]
      },
      {
        test: /\.(png|jpe?g|gif)$/,
        use: [
          {
            loader: "file-loader",
            options: {
              name: '[path][name].[ext]',
            }
          }
        ]
      }
    ]
  },
  plugins: [
    new BrowserSyncPlugin({
      host: "localhost",
      port: 3000,
      proxy: "http://localhost:3100"
    }, {
      reload: false
    }),
    new HtmlWebpackPlugin({
      name: "Arvin Sevilla",
      title: "Software Engineer",
      template: "src/index.html"
    }),
  ],
  devServer: {
    port: 3100
  },
}
